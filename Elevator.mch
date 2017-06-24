/* Elevator
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */
MACHINE
    Elevator
    
SEES
    Elevator_ctx
    
VARIABLES
    elevators, elevators_fifo
    
INVARIANT
    elevators: ELEVATOR --> FLOOR
    & elevators_fifo: ELEVATOR --> seq(FLOOR)
    
INITIALISATION
    elevators := ELEVATOR * { GROUND_FLOOR }
    || elevators_fifo := ELEVATOR * { {} }
      
OPERATIONS
    ff <-- elev_current_floor(elevator) =
        PRE
            elevator: ELEVATOR
        THEN
            ff := elevators(elevator)
        END;

    elnum <-- elev_call_elevator(floor_num) =
        PRE
            floor_num: FLOOR    
        THEN
            //TODO Decidir melhor elevador para chamar
            //TODO Adicionar andar na fila do elevador
            ANY ee WHERE ee: ELEVATOR
            THEN
                elevators_fifo(ee) := elevators_fifo(ee) <- floor_num || elnum := ee 
            END
        END

END
