/* Elevator
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */
MACHINE
    Elevator
    
SEES
    Elevator_ctx
    
VARIABLES
    current_floor, elevator_floor_order, elevator_weight, internal_door_state, floor_door_state
    
INVARIANT
    current_floor: ELEVATOR --> FLOOR
    & elevator_floor_order: ELEVATOR --> seq(FLOOR)
    & elevator_weight: ELEVATOR --> NAT
    & internal_door_state: ELEVATOR --> DOOR_STATE
    & !ee.(ee: ELEVATOR => (internal_door_state(ee) = CLOSED => elevator_weight(ee) <= WEIGHT_LIMIT))
    & floor_door_state: (FLOOR * ELEVATOR) --> DOOR_STATE
    & !(ff,ee).(ff: FLOOR & ee: ELEVATOR => (floor_door_state(ff, ee) = OPEN => current_floor(ee) = ff))
    & !(ff,ee).(ff: FLOOR & ee: ELEVATOR => (ff = current_floor(ee) => (floor_door_state(ff, ee) = internal_door_state(ee))))

INITIALISATION
    current_floor := ELEVATOR * { GROUND_FLOOR }
    || elevator_floor_order := ELEVATOR * { {} }
    || elevator_weight := ELEVATOR * { 0 }
    || internal_door_state := ELEVATOR * { CLOSED }
    || floor_door_state := (FLOOR * ELEVATOR) * { CLOSED }
      
OPERATIONS
    ff <-- elev_current_floor(ee) =
        PRE
            ee: ELEVATOR
        THEN
            ff := current_floor(ee)
        END;
        
    ww <-- elev_current_weight(ee) =
        PRE
            ee: ELEVATOR
        THEN
            ww := elevator_weight(ee)
        END;
        
    ss <-- elev_door_state(ee) =
        PRE
            ee: ELEVATOR
        THEN
            ss := internal_door_state(ee)
        END;
        
    elev_open_door(ee, ff) =
        PRE
            ee: ELEVATOR & ff: FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(ff, ee) = CLOSED
            & current_floor(ee) = ff               //o elevador está no piso daquele andar
            & elevator_floor_order(ee) /= []
            & first(elevator_floor_order(ee)) = ff //a próxima parada é naquele andar
        THEN
            internal_door_state(ee) := OPEN
            || floor_door_state(ff, ee) := OPEN
            || elevator_floor_order(ee) := tail(elevator_floor_order(ee))
        END;

     elev_close_door(ee, ff) =
        PRE
            ee: ELEVATOR & ff: FLOOR
            & internal_door_state(ee) = OPEN
            & floor_door_state(ff, ee) = OPEN
            & current_floor(ee) = ff               //o elevador está no piso daquele andar
            & elevator_weight(ee) <= WEIGHT_LIMIT
        THEN
            internal_door_state(ee) := CLOSED
            || floor_door_state(ff, ee) := CLOSED
        END;
        
    elev_go_up(ee) =
        PRE
            ee: ELEVATOR
            & elevator_floor_order(ee) /= []                      //alguém chamou o elevador
            & first(elevator_floor_order(ee)) > current_floor(ee) //a próxima parada é acima do andar atual
            & current_floor(ee) < TOP_FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(current_floor(ee), ee) = CLOSED
        THEN
            current_floor(ee) := current_floor(ee) + 1
        END;
        
    elev_go_down(ee) =
        PRE
            ee: ELEVATOR
            & elevator_floor_order(ee) /= []                      //alguém chamou o elevador
            & first(elevator_floor_order(ee)) < current_floor(ee) //a próxima parada é acima do andar atual
            & current_floor(ee) > GROUND_FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(current_floor(ee), ee) = CLOSED
        THEN
            current_floor(ee) := current_floor(ee) - 1
        END;
        
//    elev_enter(ee, uu) =


//    elev_exit(ee, uu) =
    
    

    elnum <-- elev_call_elevator(ee, ff) =
        PRE
            ee: ELEVATOR & ff: FLOOR
        THEN
            elevator_floor_order(ee) := elevator_floor_order(ee) <- ff //Adiciona andar na fila do elevador
            || elnum := ee 
        END

END
