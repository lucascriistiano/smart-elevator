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
            //TODO Select best elevator to user
            elnum <-- elev_call_elevator(desired_floor)
        END
          
//    ff <-- int_current_floor(elevator) =
//        PRE
//            elevator: ELEVATOR
//        THEN
//            ff <-- elev_current_floor(elevator)
//        END


END
