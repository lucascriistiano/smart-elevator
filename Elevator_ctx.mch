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
    FLOOR,
    GROUND_FLOOR,
    TOP_FLOOR,
    WEIGHT_LIMIT
    
PROPERTIES
    ELEVATOR = 0..2
    & FLOOR = 0..4
    & GROUND_FLOOR = 0
    & TOP_FLOOR = 4
    & WEIGHT_LIMIT: NAT1
    & min(ELEVATOR) = 0
    & max(ELEVATOR) = 2
    & min(FLOOR) = 0
    & max(FLOOR) = 4

END
