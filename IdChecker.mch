/* IdChecker
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */

MACHINE
    IdChecker

SEES
    People_ctx, Elevator_ctx, IdChecker_ctx, OperationResult_ctx

VARIABLES
    authorized_floors
    
INVARIANT
    authorized_floors: PEOPLE --> POW(FLOOR)
    
INITIALISATION
    authorized_floors := PEOPLE * { {} }

OPERATIONS
    
    auth, res <-- idchecker_check_floor_authorization(uu, ff) =
        PRE
            uu: PEOPLE & ff: FLOOR
        THEN
            IF
                uu: PEOPLE & ff: FLOOR 
            THEN
                IF
                    ff: authorized_floors(uu)
                THEN
                    auth := AUTHORIZED
                ELSE
                    auth := NOT_AUTHORIZED
                END 
                || res := SUCCESS
            ELSE
                auth := NOT_AUTHORIZED
                || res := ERROR
            END
        END;
    
    res <-- idchecker_authorize_floor(uu, ff) =
        PRE
            uu: PEOPLE & ff: FLOOR
            & ff /: authorized_floors(uu)
        THEN
            IF
                uu: PEOPLE & ff: FLOOR 
                & ff /: authorized_floors(uu)
            THEN
                authorized_floors(uu) := authorized_floors(uu) \/ { ff }
                || res := SUCCESS
            ELSE
                res := ERROR
            END
        END;
        
    res <-- idchecker_revoke_floor(uu, ff) =
        PRE
            uu: PEOPLE & ff: FLOOR
            & ff: authorized_floors(uu)
        THEN
            IF
                uu: PEOPLE & ff: FLOOR
                & ff: authorized_floors(uu)
            THEN
                authorized_floors(uu) := authorized_floors(uu) - { ff }
                || res := SUCCESS
            ELSE
                res := ERROR
            END                
        END;

    res <-- idchecker_revoke_all(uu) =
        PRE
            uu: PEOPLE
            & authorized_floors(uu) /= {}
        THEN
            IF
                uu: PEOPLE
                & authorized_floors(uu) /= {}
            THEN
                authorized_floors(uu) := {}
                || res := SUCCESS
            ELSE
                res := ERROR
            END    
        END
    
END
