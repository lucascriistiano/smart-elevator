/* ElevatorController
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */

MACHINE
    ElevatorController
    
SEES
    Elevator_ctx, People_ctx

INCLUDES
    Elevator
    
PROMOTES
    elev_go_up,
    elev_go_down,
    elev_current_floor
    
EXTENDS
    IdChecker

VARIABLES
    choosen_elevator,
    origin_floor,
    destination_floor
    
INVARIANT
    choosen_elevator: PEOPLE +-> ELEVATOR
    & origin_floor: PEOPLE +-> FLOOR
    & destination_floor: PEOPLE +-> FLOOR

INITIALISATION
    choosen_elevator := {}
    || origin_floor := {}
    || destination_floor := {}
    
OPERATIONS

    elnum <-- ctrl_call_elevator(call_floor, dest_floor, user) =
        PRE 
            call_floor: FLOOR & dest_floor: FLOOR & user: PEOPLE
            & call_floor /= dest_floor
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
                || origin_floor(user) := call_floor
                || destination_floor(user) := dest_floor
            END
        END;

    ctrl_open_door(ee, ff) =
        PRE
            ee: ELEVATOR & ff: FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(ff, ee) = CLOSED
            & current_floor(ee) = ff               //o elevador esta no piso daquele andar
            & elevator_floor_order(ee) /= []
            & first(elevator_floor_order(ee)) = ff //a proxima parada eh naquele andar
        THEN
            elev_open_door(ee, ff)
        END;

     ctrl_close_door(ee, ff) =
        PRE
            ee: ELEVATOR & ff: FLOOR
            & internal_door_state(ee) = OPEN
            & floor_door_state(ff, ee) = OPEN
            & current_floor(ee) = ff               //o elevador esta no piso daquele andar
            & elevator_weight(ee) <= WEIGHT_LIMIT
            & !uu.(uu: elevator_people(ee) => destination_floor(uu) /= ff) //nao tem mais ninguem para descer no andar
            & !uu.(uu: dom(choosen_elevator) => ((choosen_elevator(uu) = ee & origin_floor(uu) = current_floor(ee)) => uu: elevator_people(ee))) //nao tem mais ninguem para entrar no elevador no andar
        THEN
            elev_close_door(ee, ff)
        END;

    ctrl_elev_enter(ee, uu) =
        PRE
            ee: ELEVATOR & uu: PEOPLE
            & internal_door_state(ee) = OPEN
            & uu /: elevator_people(ee)
            & uu: dom(choosen_elevator)
            & choosen_elevator(uu) = ee //eh o elevador que foi escolhido para o usuario
            & uu: dom(origin_floor)
            & origin_floor(uu) = current_floor(ee) //esta no andar do usuario
        THEN
            elev_enter(ee, uu)
            || choosen_elevator := { uu } <<| choosen_elevator //remove elevador escolhido para o usuario
            || origin_floor := { uu } <<| origin_floor
        END;

    ctrl_elev_exit(ee, uu) =
        PRE
            ee: ELEVATOR & uu: PEOPLE
            & internal_door_state(ee) = OPEN
            & uu: elevator_people(ee)
            & uu: dom(destination_floor)
            & current_floor(ee) = destination_floor(uu) //eh o andar que o usuario deve descer
        THEN
            elev_exit(ee, uu)
            || destination_floor := { uu } <<| destination_floor //remove andar destino do usuario
        END

END
