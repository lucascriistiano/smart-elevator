/* WARNING if type checker is not performed, translation could contain errors ! */

#include "IdChecker.h"

/* Clause SEES */
#include "People_ctx.h"
#include "Elevator_ctx.h"
#include "IdChecker_ctx.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

/* Array and record constants */
/* Clause CONCRETE_VARIABLES */

static bool IdChecker__authorized_floors_i[5][5];
/* Clause INITIALISATION */
void IdChecker__INITIALISATION(void)
{
    
    {
        {
            int32_t pp;
            
            pp = 0;
            while((pp) < (People_ctx__PEOPLE_LIMIT))
            {
                {
                    int32_t ff;
                    
                    ff = Elevator_ctx__GROUND_FLOOR;
                    while((ff) < (Elevator_ctx__TOP_FLOOR))
                    {
                        IdChecker__authorized_floors_i[pp][ff] = false;
                        ff = ff+1;
                    }
                }
                pp = pp+1;
            }
        }
    }
}

/* Clause OPERATIONS */

void IdChecker__idchecker_check_floor_authorization(int32_t uu, int32_t ff, IdChecker_ctx__RESULT *res)
{
    {
        bool aa;

        aa = IdChecker__authorized_floors_i[uu][ff];
        if(aa == true)
        {
            (*res) = IdChecker_ctx__AUTHORIZED;
        }
        else
        {
            (*res) = IdChecker_ctx__NOT_AUTHORIZED;
        }
    }
}

void IdChecker__idchecker_authorize_floor(int32_t uu, int32_t ff)
{
    IdChecker__authorized_floors_i[uu][ff] = true;
}

void IdChecker__idchecker_revoke_floor(int32_t uu, int32_t ff)
{
    IdChecker__authorized_floors_i[uu][ff] = false;
}

void IdChecker__idchecker_revoke_all(int32_t uu)
{
    {
        int32_t ff;

        ff = Elevator_ctx__GROUND_FLOOR;
        while((ff) < (Elevator_ctx__TOP_FLOOR))
        {
            IdChecker__authorized_floors_i[uu][ff] = false;
            ff = ff+1;
        }
    }
}

