/* WARNING if type checker is not performed, translation could contain errors ! */

#include "IdChecker.h"

/* Clause SEES */
#include "People_ctx.h"
#include "Elevator_ctx.h"
#include "IdChecker_ctx.h"
#include "OperationResult_ctx.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

/* Array and record constants */
/* Clause CONCRETE_VARIABLES */

static bool IdChecker__authorized_floors_i[People_ctx__PEOPLE_LIMIT+1][Elevator_ctx__TOP_FLOOR+1];
static int32_t IdChecker__authorized_floors_num_i[People_ctx__PEOPLE_LIMIT+1];
/* Clause INITIALISATION */
void IdChecker__INITIALISATION(void)
{
    
    {
        {
            int32_t pp;
            
            pp = 0;
            while((pp) <= (People_ctx__PEOPLE_LIMIT))
            {
                IdChecker__authorized_floors_num_i[pp] = 0;
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

void IdChecker__idchecker_check_floor_authorization(int32_t uu, int32_t ff, IdChecker_ctx__RESULT *auth, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((((uu) >= (0)) &&
            ((uu) <= (People_ctx__PEOPLE_LIMIT))) &&
        ((ff) >= (Elevator_ctx__GROUND_FLOOR))) &&
    ((ff) <= (Elevator_ctx__TOP_FLOOR)))
    {
        {
            bool aa;
            
            aa = IdChecker__authorized_floors_i[uu][ff];
            if(aa == true)
            {
                (*auth) = IdChecker_ctx__AUTHORIZED;
            }
            else
            {
                (*auth) = IdChecker_ctx__NOT_AUTHORIZED;
            }
        }
        (*res) = OperationResult_ctx__SUCCESS;
    }
    else
    {
        (*auth) = IdChecker_ctx__NOT_AUTHORIZED;
        (*res) = OperationResult_ctx__ERROR;
    }
}

void IdChecker__idchecker_authorize_floor(int32_t uu, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((((uu) >= (0)) &&
            ((uu) <= (People_ctx__PEOPLE_LIMIT))) &&
        ((ff) >= (Elevator_ctx__GROUND_FLOOR))) &&
    ((ff) <= (Elevator_ctx__TOP_FLOOR)))
    {
        {
            bool aa;
            
            aa = IdChecker__authorized_floors_i[uu][ff];
            if(aa == false)
            {
                IdChecker__authorized_floors_i[uu][ff] = true;
                (*res) = OperationResult_ctx__SUCCESS;
            }
            else
            {
                (*res) = OperationResult_ctx__ERROR;
            }
        }
    }
    else
    {
        (*res) = OperationResult_ctx__ERROR;
    }
}

void IdChecker__idchecker_revoke_floor(int32_t uu, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((((uu) >= (0)) &&
            ((uu) <= (People_ctx__PEOPLE_LIMIT))) &&
        ((ff) >= (Elevator_ctx__GROUND_FLOOR))) &&
    ((ff) <= (Elevator_ctx__TOP_FLOOR)))
    {
        {
            bool aa;
            
            aa = IdChecker__authorized_floors_i[uu][ff];
            if(aa == true)
            {
                IdChecker__authorized_floors_i[uu][ff] = false;
                (*res) = OperationResult_ctx__SUCCESS;
            }
            else
            {
                (*res) = OperationResult_ctx__ERROR;
            }
        }
    }
    else
    {
        (*res) = OperationResult_ctx__ERROR;
    }
}

void IdChecker__idchecker_revoke_all(int32_t uu, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((uu) >= (0)) &&
    ((uu) <= (People_ctx__PEOPLE_LIMIT)))
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
        (*res) = OperationResult_ctx__SUCCESS;
    }
    else
    {
        (*res) = OperationResult_ctx__ERROR;
    }
}

