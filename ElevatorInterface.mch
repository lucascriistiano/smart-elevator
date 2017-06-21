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
    
EXTENDS
    IdChecker, PeopleInfo
    
OPERATIONS
    elnum <-- int_call_elevator(current_floor, desired_floor, user) =
        PRE 
            current_floor: FLOOR & desired_floor: FLOOR
            & user: PEOPLE & current_floor /= desired_floor
            & user: authorized_people
        THEN
            ANY nn WHERE nn: ELEVATOR THEN
                //TODO Select best elevator to user
                elnum := nn
            END
        END

END
