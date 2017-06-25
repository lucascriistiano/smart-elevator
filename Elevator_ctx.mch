/* Elevator_ctx
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */
MACHINE
    Elevator_ctx
    
SETS
    ELEVATOR; DOOR_STATE = {OPEN, CLOSED}
   
CONSTANTS
    FLOOR,
    GROUND_FLOOR,
    TOP_FLOOR,
    WEIGHT_LIMIT
    
PROPERTIES
    FLOOR = 0..4
    & GROUND_FLOOR = 0
    & TOP_FLOOR = 4
    & WEIGHT_LIMIT: NAT

END
