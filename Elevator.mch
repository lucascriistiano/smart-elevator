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
    elevator_floor_order,
    elevator_weight,
    internal_door_state,
    floor_door_state,
    elevator_people
//    choosen_elevator,
//    destination_floor
    
INVARIANT
    current_floor: ELEVATOR --> FLOOR
    & elevator_floor_order: ELEVATOR --> seq(FLOOR)
    & elevator_weight: ELEVATOR --> NAT
    & internal_door_state: ELEVATOR --> DOOR_STATE
    & floor_door_state: (FLOOR * ELEVATOR) --> DOOR_STATE
    & elevator_people: ELEVATOR --> POW(PEOPLE)
//    & choosen_elevator: PEOPLE +-> ELEVATOR
//    & destination_floor: PEOPLE +-> FLOOR
    & !ee.(ee: ELEVATOR => (internal_door_state(ee) = CLOSED => elevator_weight(ee) <= WEIGHT_LIMIT))
    & !(ee).(ee: ELEVATOR => elevator_weight(ee) = SIGMA uu.(uu: elevator_people(ee) | people_weight(uu)))
    & !(ff,ee).(ff: FLOOR & ee: ELEVATOR => (floor_door_state(ff, ee) = OPEN => current_floor(ee) = ff))
    & !(ff,ee).(ff: FLOOR & ee: ELEVATOR => (ff = current_floor(ee) => (floor_door_state(ff, ee) = internal_door_state(ee))))

INITIALISATION
    current_floor := ELEVATOR * { GROUND_FLOOR }
    || elevator_floor_order := ELEVATOR * { {} }
    || elevator_weight := ELEVATOR * { 0 }
    || internal_door_state := ELEVATOR * { CLOSED }
    || floor_door_state := (FLOOR * ELEVATOR) * { CLOSED }
    || elevator_people := ELEVATOR * { {} }
//    || choosen_elevator := {}
//    || destination_floor := {}
      
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
        
    elnum <-- elev_call_elevator(ee, call_floor, dest_floor) =
        PRE
            ee: ELEVATOR
            & call_floor: FLOOR
            & dest_floor: FLOOR
            & call_floor /= dest_floor
        THEN
            elevator_floor_order(ee) := elevator_floor_order(ee) ^ [ call_floor, dest_floor ] //Adiciona andar na fila do elevador
            || elnum := ee
        END;

    elev_open_door(ee, ff) =
        PRE
            ee: ELEVATOR
            & ff: FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(ff, ee) = CLOSED
            & current_floor(ee) = ff               //o elevador esta no piso daquele andar
            & elevator_floor_order(ee) /= []
            & first(elevator_floor_order(ee)) = ff //a proxima parada eh naquele andar
        THEN
            internal_door_state(ee) := OPEN
            || floor_door_state(ff, ee) := OPEN
            || elevator_floor_order(ee) := tail(elevator_floor_order(ee))
        END;

     elev_close_door(ee, ff) =
        PRE
            ee: ELEVATOR
            & ff: FLOOR
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
            ee: ELEVATOR
            & uu: PEOPLE
            & internal_door_state(ee) = OPEN
            & uu /: elevator_people(ee)
        THEN
            elevator_people(ee) := elevator_people(ee) \/ { uu }
            || elevator_weight(ee) := elevator_weight(ee) + people_weight(uu)
        END;

    elev_exit(ee, uu) =
        PRE
            ee: ELEVATOR
            & uu: PEOPLE
            & internal_door_state(ee) = OPEN
            & uu: elevator_people(ee)
        THEN
            elevator_people(ee) := elevator_people(ee) - { uu }
            || elevator_weight(ee) := elevator_weight(ee) - people_weight(uu)
        END;

    elev_go_up(ee) =
        PRE
            ee: ELEVATOR
            & elevator_floor_order(ee) /= []                      //alguem chamou o elevador
            & first(elevator_floor_order(ee)) > current_floor(ee) //a proxima parada eh acima do andar atual
            & current_floor(ee) < TOP_FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(current_floor(ee), ee) = CLOSED
        THEN
            current_floor(ee) := current_floor(ee) + 1
        END;

    elev_go_down(ee) =
        PRE
            ee: ELEVATOR
            & elevator_floor_order(ee) /= []                      //alguem chamou o elevador
            & first(elevator_floor_order(ee)) < current_floor(ee) //a proxima parada eh abaixo do andar atual
            & current_floor(ee) > GROUND_FLOOR
            & internal_door_state(ee) = CLOSED
            & floor_door_state(current_floor(ee), ee) = CLOSED
        THEN
            current_floor(ee) := current_floor(ee) - 1
        END

END
