/* People_ctx
 * Author: Lucas Cristiano C. Dantas
 * Creation date: 21/06/17
 */

MACHINE
    People_ctx

CONSTANTS
    PEOPLE,
    PEOPLE_LIMIT

PROPERTIES
    PEOPLE_LIMIT = 4
    & PEOPLE = 0..PEOPLE_LIMIT

END
