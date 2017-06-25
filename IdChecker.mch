/* IdChecker
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */
MACHINE
    IdChecker

SEES
    People_ctx, Elevator_ctx

VARIABLES
    authorized_people, authorized_floors
    
SETS
    RESULT = { authorized, not_authorized }
    
INVARIANT
    authorized_people <: PEOPLE
    & authorized_floors: authorized_people --> POW(FLOOR)
    
INITIALISATION
    authorized_people := {}
    || authorized_floors := {}

OPERATIONS
    
    idchecker_authorize(uu) =
        PRE
            uu: PEOPLE
            & uu /: authorized_people
        THEN
            authorized_people := authorized_people \/ { uu }
            || authorized_floors(uu) := {}
        END;
        
    idchecker_revoke(uu) =
        PRE uu: PEOPLE THEN
            authorized_people := authorized_people - { uu }
            || authorized_floors := { uu } <<| authorized_floors
        END;

    idchecker_revoke_floor(uu, ff) =
        PRE
            uu: authorized_people
            & ff: FLOOR
        THEN
            authorized_floors(uu) := authorized_floors(uu) - { ff }
        END;

    res <-- idchecker_check_authorization(uu) =
        PRE
            uu: PEOPLE
        THEN
            IF uu: authorized_people THEN res := authorized
            ELSE res := not_authorized
            END
        END;

    res <-- idchecker_check_floor_authorization(uu, ff) =
        PRE
            uu: PEOPLE
            & ff: FLOOR
        THEN
            IF
                uu: authorized_people
                & uu: dom(authorized_floors)
                & ff: authorized_floors(uu)
            THEN
                res := authorized
            ELSE
                res := not_authorized
            END
        END
    
END
