/* UserInfo
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 21/06/17
 */
MACHINE
    PeopleInfo
    
SEES
    People_ctx

VARIABLES
    people_weight

INVARIANT
    people_weight: PEOPLE --> NAT1
    
INITIALISATION
    ANY pw WHERE pw : PEOPLE --> NAT1 THEN people_weight := pw END

OPERATIONS
    
    peopleinfo_set_weight(user, weight) =
    PRE
        user: PEOPLE & weight: NAT1
    THEN
        people_weight(user) := weight
    END;
    
    weight <-- peopleinfo_query_weight(user) =
    PRE
        user: PEOPLE
    THEN
        weight := people_weight(user)
    END

END
