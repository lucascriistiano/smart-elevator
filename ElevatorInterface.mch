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
    elev_open_door, elev_close_door, elev_go_up, elev_go_down
    
EXTENDS
    IdChecker, PeopleInfo
    
OPERATIONS
    elnum <-- int_call_elevator(call_floor, desired_floor, user) =
        PRE 
            call_floor: FLOOR & desired_floor: FLOOR
            & user: PEOPLE & call_floor /= desired_floor
            & user: authorized_people
        THEN
            //TODO Decidir melhor elevador para chamar para o usuário
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
