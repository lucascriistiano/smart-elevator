/* Elevator_ctx
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */
MACHINE
    Elevator_ctx
    
SETS
    DOOR_STATE = {OPEN, CLOSED}; STATE = { STOPPED, MOVING}; DIRECTION = { UP, DOWN }
   
CONSTANTS
    ELEVATOR,
    ELEVATOR_LIMIT,
    FLOOR,
    GROUND_FLOOR,
    TOP_FLOOR,
    WEIGHT_LIMIT
    
PROPERTIES
    ELEVATOR_LIMIT = 2
    & ELEVATOR = 0..ELEVATOR_LIMIT
    & GROUND_FLOOR = 0
    & TOP_FLOOR = 4
    & FLOOR = 0..TOP_FLOOR
    & WEIGHT_LIMIT: NAT1

END
