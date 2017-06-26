/* ElevatorInterface
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */        
MACHINE
    ElevatorInterface
    
SEES
    Elevator_ctx, People_ctx

INCLUDES
    Elevator
    
PROMOTES
    elev_go_up,
    elev_go_down
    
EXTENDS
    IdChecker

VARIABLES
    choosen_elevator,
    destination_floor
    
INVARIANT
    choosen_elevator: PEOPLE +-> ELEVATOR
    & destination_floor: PEOPLE +-> FLOOR

INITIALISATION
    choosen_elevator := {}
    || destination_floor := {}
    
OPERATIONS

    ff <-- int_current_floor(ee) =
        PRE
            ee: ELEVATOR
        THEN
            ff <-- elev_current_floor(ee)
        END;

    elnum <-- int_call_elevator(call_floor, dest_floor, user) =
        PRE 
            call_floor: FLOOR
            & dest_floor: FLOOR
            & call_floor /= dest_floor
            & user: PEOPLE
            & dest_floor: authorized_floors(user)
            & user /: dom(choosen_elevator)               //usuario nao ja chamou elevador
            & user /: dom(destination_floor)              //usuario nao ja esta no elevador
        THEN
            //TODO Decidir melhor elevador para chamar para o usuario
            // Melhor = (que esteja indo na mesma direcao que a pessoa vai, que chegue ou passe por onde a pessoa vai, que nao ultrapasse o peso com quem esta e com quem vai entrar antes dele)
            // Só pode entrar quem ja chamou o elevador naquele andar e foi direcionado para ele

            //Lista contem onde tem que parar para pegar e deixar as pessoas
            
            ANY ee WHERE ee: ELEVATOR
            THEN
                elnum <-- elev_call_elevator(ee, call_floor, dest_floor)
                || choosen_elevator(user) := ee
                || destination_floor(user) := dest_floor
            END
        END;

    int_open_door(ee, ff) =
        PRE
            ee: ELEVATOR
            & ff: FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(ff, ee) = CLOSED
            & current_floor(ee) = ff               //o elevador esta no piso daquele andar
            & elevator_floor_order(ee) /= []
            & first(elevator_floor_order(ee)) = ff //a próxima parada eh naquele andar
        THEN
            elev_open_door(ee, ff)
        END;

     int_close_door(ee, ff) =
        PRE
            ee: ELEVATOR
            & ff: FLOOR
            & internal_door_state(ee) = OPEN
            & floor_door_state(ff, ee) = OPEN
            & current_floor(ee) = ff               //o elevador esta no piso daquele andar
            & elevator_weight(ee) <= WEIGHT_LIMIT
            & !uu.(uu: elevator_people(ee) => destination_floor(uu) /= ff) //nao tem mais ninguem para descer no andar
            & !uu.(uu: dom(choosen_elevator) => (choosen_elevator(uu) = ee => uu: elevator_people(ee))) //nao tem mais ninguem para entrar no elevador no andar
        THEN
            elev_close_door(ee, ff)
        END;

    int_elev_enter(ee, uu) =
        PRE
            ee: ELEVATOR
            & uu: PEOPLE
            & internal_door_state(ee) = OPEN
            & uu /: elevator_people(ee)
            & uu: dom(choosen_elevator)
            & choosen_elevator(uu) = ee //eh o elevador que foi escolhido para o usuario
            //esta no andar do usuario
        THEN
            elev_enter(ee, uu)
            || choosen_elevator := { uu } <<| choosen_elevator //remove elevador escolhido para o usuario
        END;

    int_elev_exit(ee, uu) =
        PRE
            ee: ELEVATOR
            & uu: PEOPLE
            & internal_door_state(ee) = OPEN
            & uu: elevator_people(ee)
            & uu: dom(destination_floor)
            & current_floor(ee) = destination_floor(uu) //eh o andar que o usuario deve descer
        THEN
            elev_exit(ee, uu)
            || destination_floor := { uu } <<| destination_floor //remove andar destino do usuario
        END

END
