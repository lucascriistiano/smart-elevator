/* UserInfo
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 21/06/17
 */
MACHINE
    PeopleInfo
    
SEES
    People_ctx, OperationResult_ctx

VARIABLES
    people_weight

INVARIANT
    people_weight: PEOPLE --> NAT1
    
INITIALISATION
    ANY pw WHERE pw : PEOPLE --> NAT1 THEN people_weight := pw END

OPERATIONS
    
    weight, res <-- peopleinfo_query_weight(user) =
        PRE
            user: PEOPLE
        THEN
            IF user: PEOPLE 
            THEN
                weight := people_weight(user)
                || res := SUCCESS
            ELSE
                weight := 1
                || res := ERROR
            END
        END;
    
    res <-- peopleinfo_set_weight(user, weight) =
        PRE
            user: PEOPLE & weight: NAT1
        THEN
            IF user: PEOPLE & weight > 0
            THEN
                people_weight(user) := weight
                || res := SUCCESS
            ELSE
                res := ERROR
            END
        END

END
