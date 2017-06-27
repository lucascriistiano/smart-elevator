/* ElevatorController
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */

MACHINE
    ElevatorController
    
SEES
    Elevator_ctx, People_ctx
    
EXTENDS
    IdChecker, PeopleInfo

VARIABLES
    current_floor,
    elevator_weight,
    internal_door_state,
    floor_door_state,
    elevator_people,
    elevator_direction,
    elevator_state,
    elevator_stops,
    
    choosen_elevator,
    origin_floor,
    destination_floor
    
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
    
    & choosen_elevator: PEOPLE +-> ELEVATOR
    & origin_floor: PEOPLE +-> FLOOR
    & destination_floor: PEOPLE +-> FLOOR

INITIALISATION
    current_floor := ELEVATOR * { GROUND_FLOOR }
    || elevator_weight := ELEVATOR * { 0 }
    || internal_door_state := ELEVATOR * { CLOSED }
    || floor_door_state := (FLOOR * ELEVATOR) * { CLOSED }
    || elevator_people := ELEVATOR * { {} }
    || elevator_direction := ELEVATOR * { UP }
    || elevator_state := ELEVATOR * { STOPPED }
    || elevator_stops := (ELEVATOR * DIRECTION) * { {} }
    
    || choosen_elevator := {}
    || origin_floor := {}
    || destination_floor := {}
    
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

    dir <-- elev_direction(ee) =
        PRE
            ee: ELEVATOR
        THEN
            dir := elevator_direction(ee)
        END;

    elnum <-- elev_call_elevator(call_floor, dest_floor, user) =
        PRE 
            call_floor: FLOOR & dest_floor: FLOOR & user: PEOPLE
            & call_floor /= dest_floor
            & dest_floor: authorized_floors(user)
            & user /: dom(choosen_elevator)               //usuario nao ja chamou elevador
            & user /: dom(destination_floor)              //usuario nao ja esta no elevador
        THEN
            //TODO Decidir melhor elevador para chamar para o usuario
            // Melhor = (que esteja indo na mesma direcao que a pessoa vai, que chegue ou passe por onde a pessoa vai, que nao ultrapasse o peso com quem esta e com quem vai entrar antes dele)
            // Só pode entrar quem ja chamou o elevador naquele andar e foi direcionado para ele

            //Lista contem onde tem que parar para pegar e deixar as pessoas
            IF call_floor < dest_floor
            THEN
                IF bool(#ee.(ee: ELEVATOR & elevator_direction(ee) = UP & elevator_weight(ee) + people_weight(user) <= WEIGHT_LIMIT)) = TRUE
                THEN
                    ANY ee WHERE ee: ELEVATOR & elevator_direction(ee) = UP & elevator_weight(ee) + people_weight(user) <= WEIGHT_LIMIT
                    THEN
                        elevator_stops(ee, UP) := elevator_stops(ee, UP) \/ { call_floor, dest_floor }
                        || choosen_elevator(user) := ee
                        || origin_floor(user) := call_floor
                        || destination_floor(user) := dest_floor
                        || elnum := ee
                    END
//                ELSE
                    //retorna um elevador qualquer mais proximo que aceite o peso do usuario
                END
//            ELSE
                   //coisa semelhante para down
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
            & !uu.(uu: elevator_people(ee) => destination_floor(uu) /= ff) //nao tem mais ninguem para descer no andar
            & !uu.(uu: dom(choosen_elevator) => ((choosen_elevator(uu) = ee & origin_floor(uu) = current_floor(ee)) => uu: elevator_people(ee))) //nao tem mais ninguem para entrar no elevador no andar
        THEN
            internal_door_state(ee) := CLOSED
            || floor_door_state(ff, ee) := CLOSED
        END;

    elev_enter(ee, uu) =
        PRE
            ee: ELEVATOR & uu: PEOPLE
            & internal_door_state(ee) = OPEN
            & uu /: elevator_people(ee)
//            & (elevator_weight(ee) + people_weight(uu)) <= WEIGHT_LIMIT
            & uu: dom(choosen_elevator)
            & choosen_elevator(uu) = ee //eh o elevador que foi escolhido para o usuario
            & uu: dom(origin_floor)
            & origin_floor(uu) = current_floor(ee) //esta no andar do usuario
        THEN
            elevator_people(ee) := elevator_people(ee) \/ { uu }
            || elevator_weight(ee) := elevator_weight(ee) + people_weight(uu)
            || choosen_elevator := { uu } <<| choosen_elevator //remove elevador escolhido para o usuario
            || origin_floor := { uu } <<| origin_floor
        END;

    elev_exit(ee, uu) =
        PRE
            ee: ELEVATOR & uu: PEOPLE
            & internal_door_state(ee) = OPEN
            & uu: elevator_people(ee)
            & uu: dom(destination_floor)
            & current_floor(ee) = destination_floor(uu) //eh o andar que o usuario deve descer
        THEN
            elevator_people(ee) := elevator_people(ee) - { uu }
            || elevator_weight(ee) := elevator_weight(ee) - people_weight(uu)
            || destination_floor := { uu } <<| destination_floor //remove andar destino do usuario
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
        END

END
