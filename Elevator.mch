/* Elevator
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */

MACHINE
    Elevator

SEES
    Elevator_ctx, People_ctx
    
EXTENDS
    PeopleInfo

VARIABLES
    current_floor,
    elevator_weight,
    internal_door_state,
    floor_door_state,
    elevator_people,
    elevator_direction,
    elevator_state,
    elevator_stops
    
INVARIANT
    current_floor: ELEVATOR --> FLOOR
    & elevator_weight: ELEVATOR --> NAT
    & internal_door_state: ELEVATOR --> DOOR_STATE
    & floor_door_state: (FLOOR * ELEVATOR) --> DOOR_STATE
    & elevator_people: ELEVATOR --> POW(PEOPLE)
    & elevator_direction: ELEVATOR --> DIRECTION
    & elevator_state: ELEVATOR --> STATE
    & elevator_stops: (ELEVATOR * DIRECTION) --> POW(FLOOR)
    & !ee.(ee: ELEVATOR => (internal_door_state(ee) = CLOSED => elevator_weight(ee) <= WEIGHT_LIMIT))
    & !(ee).(ee: ELEVATOR => elevator_weight(ee) = SIGMA uu.(uu: elevator_people(ee) | people_weight(uu)))
    & !(ff,ee).((ff: FLOOR & ee: ELEVATOR) => (floor_door_state(ff, ee) = OPEN => current_floor(ee) = ff))
    & !(ff,ee).((ff: FLOOR & ee: ELEVATOR) => (ff = current_floor(ee) => (floor_door_state(ff, ee) = internal_door_state(ee))))

INITIALISATION
    current_floor := ELEVATOR * { GROUND_FLOOR }
    || elevator_weight := ELEVATOR * { 0 }
    || internal_door_state := ELEVATOR * { CLOSED }
    || floor_door_state := (FLOOR * ELEVATOR) * { CLOSED }
    || elevator_people := ELEVATOR * { {} }
    || elevator_direction := ELEVATOR * { UP }
    || elevator_state := ELEVATOR * { STOPPED }
    || elevator_stops := (ELEVATOR * DIRECTION) * { {} }
      
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
        
    elev_add_call_stops(ee, call_floor, dest_floor) = //Adiciona andares na lista de paradas do elevador
        PRE
            ee: ELEVATOR & call_floor: FLOOR & dest_floor: FLOOR
            & call_floor /= dest_floor
        THEN
            IF call_floor < dest_floor
            THEN
                elevator_stops(ee, UP) := elevator_stops(ee, UP) \/ { call_floor, dest_floor }
            ELSE
                elevator_stops(ee, DOWN) := elevator_stops(ee, DOWN) \/ { call_floor, dest_floor }
            END
        END;

    elev_open_door(ee, ff) =
        PRE
            ee: ELEVATOR
            & ff: FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(ff, ee) = CLOSED
            & current_floor(ee) = ff               //o elevador esta no piso daquele andar
            & elevator_stops(ee, elevator_direction(ee)) /= {} //existe uma parada pendente na direcao atual
            & ff: elevator_stops(ee, elevator_direction(ee))   //o andar esta na lista de paradas da direcao atual
            & !ft.(ft: FLOOR & elevator_direction(ee) = UP & ft: elevator_stops(ee, UP) & ft /= ff => ff < ft)     //a proxima (menor) parada na subida eh naquele andar
            & !ft.(ft: FLOOR & elevator_direction(ee) = DOWN & ft: elevator_stops(ee, DOWN) & ft /= ff => ff > ft) //a proxima (maior) parada na descida eh naquele andar
        THEN
            internal_door_state(ee) := OPEN
            || floor_door_state(ff, ee) := OPEN
            || elevator_stops(ee, elevator_direction(ee)) := elevator_stops(ee, elevator_direction(ee)) - { min(elevator_stops(ee, elevator_direction(ee))) }
        END;

     elev_close_door(ee, ff) =
        PRE
            ee: ELEVATOR & ff: FLOOR
            & internal_door_state(ee) = OPEN
            & floor_door_state(ff, ee) = OPEN
            & current_floor(ee) = ff               //o elevador esta no piso daquele andar
            & elevator_weight(ee) <= WEIGHT_LIMIT
        THEN
            internal_door_state(ee) := CLOSED
            || floor_door_state(ff, ee) := CLOSED
        END;
        
    elev_enter(ee, uu) =
        PRE
            ee: ELEVATOR & uu: PEOPLE
            & internal_door_state(ee) = OPEN
            & uu /: elevator_people(ee)
            & (elevator_weight(ee) + people_weight(uu)) <= WEIGHT_LIMIT
        THEN
            elevator_people(ee) := elevator_people(ee) \/ { uu }
            || elevator_weight(ee) := elevator_weight(ee) + people_weight(uu)
        END;

    elev_exit(ee, uu) =
        PRE
            ee: ELEVATOR & uu: PEOPLE
            & internal_door_state(ee) = OPEN
            & uu: elevator_people(ee)
        THEN
            elevator_people(ee) := elevator_people(ee) - { uu }
            || elevator_weight(ee) := elevator_weight(ee) - people_weight(uu)
        END;

    elev_go_up(ee) =
        PRE
            ee: ELEVATOR
            & elevator_stops(ee, elevator_direction(ee)) /= {}  //alguem chamou o elevador
            & elevator_direction(ee) = UP
            & min(elevator_stops(ee, UP)) > current_floor(ee) //a proxima parada eh acima do andar atual
            & current_floor(ee) < TOP_FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(current_floor(ee), ee) = CLOSED
        THEN
            current_floor(ee) := current_floor(ee) + 1
        END;

    elev_go_down(ee) =
        PRE
            ee: ELEVATOR
            & elevator_stops(ee, elevator_direction(ee)) /= {}  //alguem chamou o elevador
            & elevator_direction(ee) = DOWN
            & max(elevator_stops(ee, DOWN)) < current_floor(ee) //a proxima parada eh abaixo do andar atual
            & current_floor(ee) > GROUND_FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(current_floor(ee), ee) = CLOSED
        THEN
            current_floor(ee) := current_floor(ee) - 1
        END;
        
    dir <-- elev_query_direction(ee) =
        PRE
            ee: ELEVATOR
        THEN
            dir := elevator_direction(ee)
        END;

    dir <-- elev_calc_direction(orig_floor, dest_floor) =
        PRE
            orig_floor: FLOOR & dest_floor: FLOOR
            & orig_floor /= dest_floor
        THEN
            IF
                orig_floor < dest_floor
            THEN
                dir := UP
            ELSE
                dir := DOWN
            END
        END

END
