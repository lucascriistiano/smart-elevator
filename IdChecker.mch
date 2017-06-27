/* IdChecker
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */

MACHINE
    IdChecker

SEES
    People_ctx, Elevator_ctx, IdChecker_ctx

VARIABLES
    authorized_floors
    
INVARIANT
    authorized_floors: PEOPLE --> POW(FLOOR)
    
INITIALISATION
    authorized_floors := PEOPLE * { {} }

OPERATIONS
    
    res <-- idchecker_check_floor_authorization(uu, ff) =
        PRE
            uu: PEOPLE & ff: FLOOR
            & uu: dom(authorized_floors)
        THEN
            IF
                ff: authorized_floors(uu)
            THEN
                res := AUTHORIZED
            ELSE
                res := NOT_AUTHORIZED
            END
        END;
    
    idchecker_authorize_floor(uu, ff) =
        PRE
            uu: PEOPLE & ff: FLOOR
            & uu: dom(authorized_floors)
            & ff /: authorized_floors(uu)
        THEN
            authorized_floors(uu) := authorized_floors(uu) \/ { ff }
        END;
        
    idchecker_revoke_floor(uu, ff) =
        PRE
            uu: PEOPLE & ff: FLOOR
            & uu: dom(authorized_floors)
            & ff: authorized_floors(uu)
        THEN
            authorized_floors(uu) := authorized_floors(uu) - { ff }
        END;

    idchecker_revoke_all(uu) =
        PRE
            uu: PEOPLE
            & uu: dom(authorized_floors)
            & authorized_floors(uu) /= {}
        THEN
            authorized_floors(uu) := {}
        END
    
END
