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
    elev_open_door,
    elev_close_door,
    elev_go_up,
    elev_go_down
    
EXTENDS
    IdChecker

VARIABLES
    choosen_elevator,
    destination_floor
    //people_floor
    
INVARIANT
    choosen_elevator: PEOPLE +-> ELEVATOR
    & destination_floor: PEOPLE +-> FLOOR
    //& people_floor: PEOPLE --> FLOOR

INITIALISATION
    choosen_elevator := {}
    || destination_floor := {}
    //|| people_floor := PEOPLE * { GROUND_FLOOR }
    
OPERATIONS
    elnum <-- int_call_elevator(call_floor, desired_floor, user) =
        PRE 
            call_floor: FLOOR
            & desired_floor: FLOOR
            & user: PEOPLE
            & call_floor /= desired_floor
            & desired_floor: authorized_floors(user)
        THEN
            //TODO Decidir melhor elevador para chamar para o usuario
            // Melhor = (que esteja indo na mesma direcao que a pessoa vai, que chegue ou passe por onde a pessoa vai, que nao ultrapasse o peso com quem esta e com quem vai entrar antes dele)
            // Só pode entrar quem ja chamou o elevador naquele andar e foi direcionado para ele

            //Lista contem onde tem que parar para pegar e deixar as pessoas
            
            ANY ee WHERE ee: ELEVATOR
            THEN
                elnum <-- elev_call_elevator(ee, desired_floor)
                || choosen_elevator(user) := ee
                || destination_floor(user) := desired_floor
            END
        END;
          
    ff <-- int_current_floor(ee) =
        PRE
            ee: ELEVATOR
        THEN
            ff <-- elev_current_floor(ee)
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
            //TODO Verificar ao fechar a porta no andar se ninguem mais tem que descer no andar
        THEN
            elev_exit(ee, uu)
            || destination_floor := { uu } <<| destination_floor //remove andar destino do usuario
        END

END
