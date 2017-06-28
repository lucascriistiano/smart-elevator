/* ElevatorController
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */

MACHINE
    ElevatorController
    
SEES
    Elevator_ctx, People_ctx, OperationResult_ctx
    
INCLUDES
    IdChecker, PeopleInfo
    
PROMOTES
    idchecker_check_floor_authorization,
    peopleinfo_query_weight

VARIABLES
    current_floor,
    elevator_weight,
    internal_door_state,
    floor_door_state,
    elevator_people,
    choosen_elevator,
    origin_floor,
    destination_floor,
    elevator_floor_sequence
    
INVARIANT
    current_floor: ELEVATOR --> FLOOR
    & elevator_weight: ELEVATOR --> NAT
    & internal_door_state: ELEVATOR --> DOOR_STATE
    & floor_door_state: (FLOOR * ELEVATOR) --> DOOR_STATE
    & elevator_people: ELEVATOR --> POW(PEOPLE)
    & choosen_elevator: PEOPLE +-> ELEVATOR
    & origin_floor: PEOPLE +-> FLOOR
    & destination_floor: PEOPLE +-> FLOOR
    & elevator_floor_sequence: ELEVATOR --> seq(FLOOR)
    & !ee.(ee: ELEVATOR => (internal_door_state(ee) = CLOSED => elevator_weight(ee) <= WEIGHT_LIMIT))
    & !(ee).(ee: ELEVATOR => elevator_weight(ee) = SIGMA uu.(uu: elevator_people(ee) | people_weight(uu)))
    & !(ff,ee).((ff: FLOOR & ee: ELEVATOR) => (floor_door_state(ff, ee) = OPEN => current_floor(ee) = ff))
    & !(ff,ee).((ff: FLOOR & ee: ELEVATOR) => (ff = current_floor(ee) => (floor_door_state(ff, ee) = internal_door_state(ee))))
    & !uu.(uu: PEOPLE & uu: dom(destination_floor) => (destination_floor(uu): authorized_floors(uu)))
    & !ee.((ee: ELEVATOR & elevator_floor_sequence(ee) = {}) => card(elevator_people(ee)) = 0)
    & !ee.((ee: ELEVATOR & card(elevator_people(ee)) > 0) => elevator_floor_sequence(ee) /= {})

INITIALISATION
    current_floor := ELEVATOR * { GROUND_FLOOR }
    || elevator_weight := ELEVATOR * { 0 }
    || internal_door_state := ELEVATOR * { CLOSED }
    || floor_door_state := (FLOOR * ELEVATOR) * { CLOSED }
    || elevator_people := ELEVATOR * { {} }
    || choosen_elevator := {}
    || origin_floor := {}
    || destination_floor := {}
    || elevator_floor_sequence := ELEVATOR * { {} }
    
OPERATIONS
    
    ff, res <-- elev_current_floor(ee) =
        PRE
            ee: ELEVATOR
        THEN
            IF ee: ELEVATOR
            THEN
                ff := current_floor(ee)
                || res := SUCCESS
            ELSE
                ff := 0
                || res := ERROR
            END
        END;
        
    ww, res <-- elev_current_weight(ee) =
        PRE
            ee: ELEVATOR
        THEN
            IF ee: ELEVATOR
            THEN
                ww := elevator_weight(ee)
                || res := SUCCESS
            ELSE
                ww := 0
                || res := ERROR
            END
        END;
        
    ss, res <-- elev_door_state(ee) =
        PRE
            ee: ELEVATOR
        THEN
            IF ee: ELEVATOR
            THEN
                ss := internal_door_state(ee)
                || res := SUCCESS
            ELSE
                ss := OPEN
                || res := ERROR
            END
        END;

    dir, state, res <-- elev_direction(ee) =
        PRE
            ee: ELEVATOR
        THEN
            IF ee: ELEVATOR
            THEN
                IF elevator_floor_sequence(ee) /= {}
                THEN
                    IF current_floor(ee) > first(elevator_floor_sequence(ee))
                    THEN
                        dir := DOWN
                    ELSIF current_floor(ee) < first(elevator_floor_sequence(ee))
                    THEN
                        dir := UP
                    ELSE
                        dir := NONE
                    END
                    || state := ATTENDING
                ELSE
                    dir := NONE
                    || state := FREE
                END
                || res := SUCCESS
            ELSE
                dir := NONE
                || state := ATTENDING
                || res := ERROR
            END
        END;

    elnum, res <-- elev_call_elevator(call_floor, dest_floor, user) =
        PRE 
            call_floor: FLOOR & dest_floor: FLOOR & user: PEOPLE
            & call_floor /= dest_floor              //pisos de origem e destino sao diferentes
            & dest_floor: authorized_floors(user)   //o usuario tem permissao para ir para o piso selecionado
            & user /: dom(choosen_elevator)         //o usuario nao ja chamou elevador
            & user /: dom(destination_floor)        //o usuario nao ja esta no elevador
        THEN
            IF
                call_floor: FLOOR & dest_floor: FLOOR & user: PEOPLE
                & call_floor /= dest_floor
                & dest_floor: authorized_floors(user)
                & user /: dom(choosen_elevator)
                & user /: dom(destination_floor)
            THEN
                //TODO Decidir melhor elevador para chamar para o usuario
                // Melhor = que esteja indo na mesma direcao
                //          que nao ultrapasse o peso com quem esta e com quem vai entrar e sair antes dele
                //          se nenhum atender, outro que esteja mais proximo no sentido oposto

                IF call_floor < dest_floor
                THEN
                    //usuario indo para cima
                    IF bool(#ee.(
                            ee: ELEVATOR
                            & elevator_floor_sequence(ee) /= {}
                            & current_floor(ee) < first(elevator_floor_sequence(ee)) //elevador esta subindo
                            & call_floor >= current_floor(ee)
                            & dest_floor <= first(elevator_floor_sequence(ee))
                            //peso atual + soma do peso de quem vai entrar antes ou no piso - soma do peso de quem vai sair antes ou no piso
                            & (elevator_weight(ee)
                                + SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & origin_floor(uu) <= call_floor | people_weight(uu))
                                - SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & destination_floor(uu) <= call_floor | people_weight(uu)))
                                    <= WEIGHT_LIMIT)) = TRUE
                    THEN
                        //existe um elevador otimizado para subir
                        ANY ee
                        WHERE
                            ee: ELEVATOR
                            & elevator_floor_sequence(ee) /= {}
                            & current_floor(ee) < first(elevator_floor_sequence(ee)) //elevador esta subindo
                            & call_floor >= current_floor(ee)
                            & dest_floor <= first(elevator_floor_sequence(ee))
                            //peso atual + soma do peso de quem vai entrar antes ou no piso - soma do peso de quem vai sair antes ou no piso
                            & (elevator_weight(ee)
                                + SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & origin_floor(uu) <= call_floor | people_weight(uu))
                                - SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & destination_floor(uu) <= call_floor | people_weight(uu)))
                                    <= WEIGHT_LIMIT
                        THEN
                            choosen_elevator(user) := ee
                            || origin_floor(user) := call_floor
                            || destination_floor(user) := dest_floor
                            || elnum := ee
                            || res := SUCCESS
                        END

                    ELSIF bool(#ee.(
                               ee: ELEVATOR
                               //peso atual + soma do peso de quem vai entrar antes ou no piso - soma do peso de quem vai sair antes ou no piso
                               & (elevator_weight(ee)
                                   + SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & origin_floor(uu) <= call_floor | people_weight(uu))
                                   - SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & destination_floor(uu) <= call_floor | people_weight(uu)))
                                       <= WEIGHT_LIMIT)) = TRUE
                    THEN
                        //existe um elevador com capacidade suficiente livre para subir
                        ANY ee
                        WHERE
                            ee: ELEVATOR
                           //peso atual + soma do peso de quem vai entrar antes ou no piso - soma do peso de quem vai sair antes ou no piso
                           & (elevator_weight(ee)
                               + SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & origin_floor(uu) <= call_floor | people_weight(uu))
                               - SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & destination_floor(uu) <= call_floor | people_weight(uu)))
                                   <= WEIGHT_LIMIT
                        THEN
//                            IF call_floor /= last(elevator_floor_sequence(ee))
//                            THEN
//                                elevator_floor_sequence(ee) := elevator_floor_sequence(ee) ^ [ call_floor, dest_floor ]
//                            ELSIF dest_floor /= last(elevator_floor_sequence(ee))
//                            THEN
//                                elevator_floor_sequence(ee) := elevator_floor_sequence(ee) ^ [ dest_floor ]
//                            END
                            elevator_floor_sequence(ee) := elevator_floor_sequence(ee) ^ [ call_floor, dest_floor ]
                            || choosen_elevator(user) := ee
                            || origin_floor(user) := call_floor
                            || destination_floor(user) := dest_floor
                            || elnum := ee
                            || res := SUCCESS
                        END

                    ELSE
                        //nao existe um elevador otimizado para subir
                        elnum := 0
                        || res := ERROR
                    END
                ELSE
                    //usuario indo para baixo
                    IF bool(#ee.(
                            ee: ELEVATOR
                            & elevator_floor_sequence(ee) /= {}
                            & current_floor(ee) > first(elevator_floor_sequence(ee)) //elevador esta descendo
                            & call_floor <= current_floor(ee)
                            & dest_floor >= first(elevator_floor_sequence(ee))
                            //peso atual + soma do peso de quem vai entrar antes ou no piso - soma do peso de quem vai sair antes ou no piso
                            & (elevator_weight(ee)
                                + SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & origin_floor(uu) >= call_floor | people_weight(uu))
                                - SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & destination_floor(uu) >= call_floor | people_weight(uu)))
                                    <= WEIGHT_LIMIT)) = TRUE
                    THEN
                        //existe um elevador otimizado para descer
                        ANY ee
                        WHERE
                            ee: ELEVATOR
                            & elevator_floor_sequence(ee) /= {}
                            & current_floor(ee) > first(elevator_floor_sequence(ee)) //elevador esta descendo
                            & call_floor <= current_floor(ee)
                            & dest_floor >= first(elevator_floor_sequence(ee))
                            //peso atual + soma do peso de quem vai entrar antes ou no piso - soma do peso de quem vai sair antes ou no piso
                            & (elevator_weight(ee)
                                + SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & origin_floor(uu) >= call_floor | people_weight(uu))
                                - SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & destination_floor(uu) >= call_floor | people_weight(uu)))
                                    <= WEIGHT_LIMIT
                        THEN
                            choosen_elevator(user) := ee
                            || origin_floor(user) := call_floor
                            || destination_floor(user) := dest_floor
                            || elnum := ee
                            || res := SUCCESS
                        END

                     ELSIF bool(#ee.(
                               ee: ELEVATOR
                               //peso atual + soma do peso de quem vai entrar antes ou no piso - soma do peso de quem vai sair antes ou no piso
                               & (elevator_weight(ee)
                                   + SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & origin_floor(uu) >= call_floor | people_weight(uu))
                                   - SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & destination_floor(uu) >= call_floor | people_weight(uu)))
                                       <= WEIGHT_LIMIT)) = TRUE
                    THEN
                        //existe um elevador com capacidade suficiente livre para descer
                        ANY ee
                        WHERE
                            ee: ELEVATOR
                           //peso atual + soma do peso de quem vai entrar antes ou no piso - soma do peso de quem vai sair antes ou no piso
                           & (elevator_weight(ee)
                               + SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & origin_floor(uu) >= call_floor | people_weight(uu))
                               - SIGMA uu.(uu: PEOPLE & uu: dom(choosen_elevator |> {ee}) & destination_floor(uu) >= call_floor | people_weight(uu)))
                                   <= WEIGHT_LIMIT
                        THEN
                            elevator_floor_sequence(ee) := elevator_floor_sequence(ee) ^ [ call_floor, dest_floor ]
                            || choosen_elevator(user) := ee
                            || origin_floor(user) := call_floor
                            || destination_floor(user) := dest_floor
                            || elnum := ee
                            || res := SUCCESS
                        END

                    ELSE
                        //nao existe um elevador otimizado para descer
                        elnum := 0
                        || res := ERROR
                    END
                END
            ELSE
                //nao atende ifs da precondicao
                elnum := 0
                || res := ERROR
            END
        END;

    res <-- elev_open_door(ee, ff) =
        PRE
            ee: ELEVATOR & ff: FLOOR
            & internal_door_state(ee) = CLOSED     //a porta interna esta fechada
            & floor_door_state(ff, ee) = CLOSED    //a porta externa esta fechada
            & current_floor(ee) = ff               //o elevador esta no piso informado
            & (ff: ran(elevator_people(ee) <| destination_floor) //existe alguem para descer no andar
                or
               ff: ran(dom(choosen_elevator |> {ee}) <| origin_floor)) //existe alguem para subir no andar

//            & elevator_stops(ee, elevator_direction(ee)) /= {} //existe uma parada pendente na direcao atual
//            & ff: elevator_stops(ee, elevator_direction(ee))   //o andar esta na lista de paradas da direcao atual
//            & !ft.(ft: FLOOR & elevator_direction(ee) = UP & ft: elevator_stops(ee, UP) & ft /= ff => ff < ft)     //a proxima (menor) parada na subida eh naquele andar
//            & !ft.(ft: FLOOR & elevator_direction(ee) = DOWN & ft: elevator_stops(ee, DOWN) & ft /= ff => ff > ft) //a proxima (maior) parada na descida eh naquele andar
        THEN
            IF
                ee: ELEVATOR & ff: FLOOR
                & internal_door_state(ee) = CLOSED     //a porta interna esta fechada
                & floor_door_state(ff, ee) = CLOSED    //a porta externa esta fechada
                & current_floor(ee) = ff               //o elevador esta no piso informado
                & (ff: ran(elevator_people(ee) <| destination_floor) //existe alguem para descer no andar
                    or
                   ff: ran(dom(choosen_elevator |> {ee}) <| origin_floor)) //existe alguem para subir no andar
            THEN
                internal_door_state(ee) := OPEN
                || floor_door_state(ff, ee) := OPEN
                || res := SUCCESS
            ELSE
                res := ERROR
            END
        END;

     res <-- elev_close_door(ee, ff) =
        PRE
            ee: ELEVATOR & ff: FLOOR
            & internal_door_state(ee) = OPEN        //a porta interna esta aberta
            & floor_door_state(ff, ee) = OPEN       //a porta externa esta aberta
            & current_floor(ee) = ff                //o elevador esta no piso informado
            & elevator_weight(ee) <= WEIGHT_LIMIT   //o peso total do elevador esta dentro do limite
            & !uu.(uu: elevator_people(ee) => destination_floor(uu) /= ff) //nao tem mais ninguem para descer no andar
            & !uu.(uu: dom(choosen_elevator) => ((choosen_elevator(uu) = ee & origin_floor(uu) = current_floor(ee)) => uu: elevator_people(ee))) //nao tem mais ninguem para entrar no elevador no andar
        THEN
            IF
                ee: ELEVATOR & ff: FLOOR
                & internal_door_state(ee) = OPEN
                & floor_door_state(ff, ee) = OPEN
                & current_floor(ee) = ff
                & elevator_weight(ee) <= WEIGHT_LIMIT
                & !uu.(uu: elevator_people(ee) => destination_floor(uu) /= ff)
                & !uu.(uu: dom(choosen_elevator) => ((choosen_elevator(uu) = ee & origin_floor(uu) = current_floor(ee)) => uu: elevator_people(ee)))
            THEN
                internal_door_state(ee) := CLOSED
                || floor_door_state(ff, ee) := CLOSED
                || IF current_floor(ee) = first(elevator_floor_sequence(ee))  //TODO Check
                   THEN
                       elevator_floor_sequence(ee) := tail(elevator_floor_sequence(ee))
                   END
                || res := SUCCESS
            ELSE
                res := ERROR
            END
        END;

    res <-- elev_enter(ee, uu) =
        //somente pode entrar quem ja chamou o elevador naquele andar e foi direcionado para ele
        PRE
            ee: ELEVATOR & uu: PEOPLE
            & internal_door_state(ee) = OPEN                  //a porta interna esta aberta
            & floor_door_state(current_floor(ee), ee) = OPEN  //a porta externa esta aberta
            & uu /: elevator_people(ee)                       //o usuario nao esta dentro do elevador
            & (elevator_weight(ee) + people_weight(uu)) <= WEIGHT_LIMIT   //peso nao vai ser excedido com o peso do usuario //TODO Check
            & uu: dom(choosen_elevator)                       //o usuario possui um elevador de entrada cadastrado
            & choosen_elevator(uu) = ee                       //eh o elevador que foi escolhido para o usuario
            & uu: dom(origin_floor)                           //o usuario possui um piso de entrada cadastrado
            & origin_floor(uu) = current_floor(ee)            //esta no piso de entrada do usuario
        THEN
            IF
                ee: ELEVATOR & uu: PEOPLE
                & internal_door_state(ee) = OPEN
                & floor_door_state(current_floor(ee), ee) = OPEN
                & uu /: elevator_people(ee)
                & (elevator_weight(ee) + people_weight(uu)) <= WEIGHT_LIMIT  //TODO Check
                & uu: dom(choosen_elevator)
                & choosen_elevator(uu) = ee
                & uu: dom(origin_floor)
                & origin_floor(uu) = current_floor(ee)
            THEN
                elevator_people(ee) := elevator_people(ee) \/ { uu }
                || elevator_weight(ee) := elevator_weight(ee) + people_weight(uu)
                || choosen_elevator := { uu } <<| choosen_elevator //remove elevador escolhido para o usuario
                || origin_floor := { uu } <<| origin_floor
                || res := SUCCESS
            ELSE
                res := ERROR
            END
        END;

    res <-- elev_exit(ee, uu) =
        PRE
            ee: ELEVATOR & uu: PEOPLE
            & internal_door_state(ee) = OPEN                  //a porta interna esta aberta
            & floor_door_state(current_floor(ee), ee) = OPEN  //a porta externa esta aberta
            & uu: elevator_people(ee)                         //o usuario esta dentro do elevador
            & uu: dom(destination_floor)                      //o usuario possui um destino cadastrado
            & current_floor(ee) = destination_floor(uu)       //o andar atual eh o destino do usuario
        THEN
            IF
                ee: ELEVATOR & uu: PEOPLE
                & internal_door_state(ee) = OPEN
                & floor_door_state(current_floor(ee), ee) = OPEN
                & uu: elevator_people(ee)
                & uu: dom(destination_floor)
                & current_floor(ee) = destination_floor(uu)
            THEN
                elevator_people(ee) := elevator_people(ee) - { uu }
                || elevator_weight(ee) := elevator_weight(ee) - people_weight(uu)
                || destination_floor := { uu } <<| destination_floor //remove andar destino do usuario
                || res := SUCCESS
            ELSE
                res := ERROR
            END
        END;

    res <-- elev_go_up(ee) =
        PRE
            ee: ELEVATOR
            & elevator_floor_sequence(ee) /= {}                      //alguem chamou o elevador
            & current_floor(ee) < first(elevator_floor_sequence(ee)) //esta indo para cima e a proxima parada eh acima do andar atual
            & current_floor(ee) < TOP_FLOOR                          //esta abaixo do ultimo piso
            & internal_door_state(ee) = CLOSED                       //a porta interna esta fechada
            & floor_door_state(current_floor(ee), ee) = CLOSED       //a porta externa esta fechada
            & current_floor(ee) /: ran(elevator_people(ee) <| destination_floor)      //nao existe alguem para descer no andar
            & current_floor(ee) /: ran(dom(choosen_elevator |> {ee}) <| origin_floor) //nao existe alguem para subir no andar
        THEN
            IF
                ee: ELEVATOR
                & elevator_floor_sequence(ee) /= {}
                & current_floor(ee) < first(elevator_floor_sequence(ee))
                & current_floor(ee) < TOP_FLOOR
                & internal_door_state(ee) = CLOSED
                & floor_door_state(current_floor(ee), ee) = CLOSED
                & current_floor(ee) /: ran(elevator_people(ee) <| destination_floor)
                & current_floor(ee) /: ran(dom(choosen_elevator |> {ee}) <| origin_floor)
            THEN
                current_floor(ee) := current_floor(ee) + 1
//                || IF current_floor(ee) + 1 /: ran(elevator_people(ee) <| destination_floor)
//                      & current_floor(ee) + 1 /: ran(dom(choosen_elevator |> {ee}) <| origin_floor)
//                      & current_floor(ee) + 1 = first(elevator_floor_sequence(ee))  //nao tem ninguem pra descer ou subir no andar seguinte, entao remove da lista
//                   THEN
//                       elevator_floor_sequence(ee) := tail(elevator_floor_sequence(ee))
//                   END
                || res := SUCCESS
            ELSE
                res := ERROR
            END
        END;

    res <-- elev_go_down(ee) =
        PRE
            ee: ELEVATOR
            & elevator_floor_sequence(ee) /= {}                      //alguem chamou o elevador
            & current_floor(ee) > first(elevator_floor_sequence(ee)) //esta indo para baixo e a proxima parada eh abaixo do andar atual
            & current_floor(ee) > GROUND_FLOOR                       //esta acima do primeiro piso
            & internal_door_state(ee) = CLOSED                       //a porta interna esta fechada
            & floor_door_state(current_floor(ee), ee) = CLOSED       //a porta externa esta fechada
            & current_floor(ee) /: ran(elevator_people(ee) <| destination_floor)      //nao existe alguem para descer no andar
            & current_floor(ee) /: ran(dom(choosen_elevator |> {ee}) <| origin_floor) //nao existe alguem para subir no andar
        THEN
            IF
                ee: ELEVATOR
                & elevator_floor_sequence(ee) /= {}
                & current_floor(ee) > first(elevator_floor_sequence(ee))
                & current_floor(ee) > GROUND_FLOOR
                & internal_door_state(ee) = CLOSED
                & floor_door_state(current_floor(ee), ee) = CLOSED
                & current_floor(ee) /: ran(elevator_people(ee) <| destination_floor)
                & current_floor(ee) /: ran(dom(choosen_elevator |> {ee}) <| origin_floor)
            THEN
                current_floor(ee) := current_floor(ee) - 1
//                || IF current_floor(ee) - 1 /: ran(elevator_people(ee) <| destination_floor)
//                      & current_floor(ee) - 1 /: ran(dom(choosen_elevator |> {ee}) <| origin_floor)
//                      & current_floor(ee) - 1 = first(elevator_floor_sequence(ee))  //nao tem ninguem pra descer ou subir no andar seguinte, entao remove da lista
//                   THEN
//                       elevator_floor_sequence(ee) := tail(elevator_floor_sequence(ee))
//                   END
                || res := SUCCESS
            ELSE
                res := ERROR
            END
        END;
    
    res <-- peopleinfo_set_weight_roubust(uu, ww) =
        PRE
            uu: PEOPLE & ww: NAT1
            & !ee.(ee:ELEVATOR => uu /: elevator_people(ee))
        THEN
            IF
                uu: PEOPLE & ww > 0
                & !ee.(ee:ELEVATOR => uu /: elevator_people(ee))
            THEN
                res <-- peopleinfo_set_weight(uu, ww)
            ELSE
                res := ERROR
            END
        END;
        
    res <-- idchecker_authorize_floor_robust(uu, ff) =
        PRE
            uu: PEOPLE & ff: FLOOR
            & ff /: authorized_floors(uu)
            & !ee.(ee:ELEVATOR => uu /: elevator_people(ee))
            & uu /: dom(origin_floor)
            & uu /: dom(destination_floor)
        THEN
            IF
                uu: PEOPLE & ff: FLOOR 
                & ff /: authorized_floors(uu)
                & !ee.(ee:ELEVATOR => uu /: elevator_people(ee))
                & uu /: dom(origin_floor)
                & uu /: dom(destination_floor)
            THEN
                res <-- idchecker_authorize_floor(uu, ff)
            ELSE
                res := ERROR
            END
        END;
        
    res <-- idchecker_revoke_floor_robust(uu, ff) =
        PRE
            uu: PEOPLE & ff: FLOOR
            & ff: authorized_floors(uu)
            & !ee.(ee:ELEVATOR => uu /: elevator_people(ee))
            & uu /: dom(origin_floor)
            & uu /: dom(destination_floor)
        THEN
            IF
                uu: PEOPLE & ff: FLOOR
                & ff: authorized_floors(uu)
                & !ee.(ee:ELEVATOR => uu /: elevator_people(ee))
                & uu /: dom(origin_floor)
                & uu /: dom(destination_floor)
            THEN
                res <-- idchecker_revoke_floor(uu, ff)
            ELSE
                res := ERROR
            END
        END;

    res <-- idchecker_revoke_all_robust(uu) =
        PRE
            uu: PEOPLE
            & authorized_floors(uu) /= {}
            & !ee.(ee:ELEVATOR => uu /: elevator_people(ee))
            & uu /: dom(origin_floor)
            & uu /: dom(destination_floor)
        THEN
            IF
                uu: PEOPLE
                & authorized_floors(uu) /= {}
                & !ee.(ee:ELEVATOR => uu /: elevator_people(ee))
                & uu /: dom(origin_floor)
                & uu /: dom(destination_floor)
            THEN
                res <-- idchecker_revoke_all(uu)
            ELSE
                res := ERROR
            END    
        END

END
