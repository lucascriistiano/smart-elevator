/* IdChecker
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 19/06/17
 */
MACHINE
    IdChecker

SEES
    People_ctx

VARIABLES
    authorized_people
    
SETS
    RESULT = { authorized, not_authorized }
    
INVARIANT
    authorized_people <: PEOPLE
    
INITIALISATION
    authorized_people := {}

OPERATIONS
    
    idchecker_authorize(user) =
        PRE user : PEOPLE THEN
            authorized_people := authorized_people \/ { user }
        END;
        
    idchecker_revoke(user) =
        PRE user : PEOPLE THEN
            authorized_people := authorized_people - { user }
        END; 

    res <-- idchecker_check_authorization(user) =
        PRE user : PEOPLE THEN
            IF user: authorized_people THEN res := authorized
            ELSE res := not_authorized
            END
        END
    
END
