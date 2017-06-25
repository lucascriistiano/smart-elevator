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
    IdChecker, PeopleInfo
    
//VARIABLES
//    people_floor
//    
//INVARIANT
//    people_floor: PEOPLE --> FLOOR
//    
//INITIALISATION
//    people_floor := PEOPLE * { GROUND_FLOOR }
    
OPERATIONS
    elnum <-- int_call_elevator(call_floor, desired_floor, user) =
        PRE 
            call_floor: FLOOR & desired_floor: FLOOR
            & user: PEOPLE & call_floor /= desired_floor
            & user: authorized_people
        THEN
            //TODO Decidir melhor elevador para chamar para o usuario
            // Melhor = (que esteja indo na mesma direcao que a pessoa vai, que chegue ou passe por onde a pessoa vai, que nao ultrapasse o peso com quem esta e com quem vai entrar antes dele)
            // Só pode entrar quem ja chamou o elevador naquele andar e foi direcionado para ele

            //Lista contem onde tem que parar para pegar e deixar as pessoas
            
            ANY ee WHERE ee: ELEVATOR
            THEN
                elnum <-- elev_call_elevator(ee, desired_floor)
            END
        END;
          
    ff <-- int_current_floor(elevator) =
        PRE
            elevator: ELEVATOR
        THEN
            ff <-- elev_current_floor(elevator)
        END


END
