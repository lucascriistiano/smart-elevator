/* WARNING if type checker is not performed, translation could contain errors ! */

#include "PeopleInfo.h"

/* Clause SEES */
#include "People_ctx.h"
#include "OperationResult_ctx.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

/* Array and record constants */
/* Clause CONCRETE_VARIABLES */

static int32_t PeopleInfo__people_weight[People_ctx__PEOPLE_LIMIT+1];
/* Clause INITIALISATION */
void PeopleInfo__INITIALISATION(void)
{
    
    {
        {
            int32_t pp;
            
            pp = 0;
            while((pp) <= (People_ctx__PEOPLE_LIMIT))
            {
                PeopleInfo__people_weight[pp] = pp+1;
                pp = pp+1;
            }
        }
    }
}

/* Clause OPERATIONS */

void PeopleInfo__peopleinfo_query_weight(int32_t user, int32_t *weight, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((user) >= (0)) &&
    ((user) <= (People_ctx__PEOPLE_LIMIT)))
    {
        (*weight) = PeopleInfo__people_weight[user];
        (*res) = OperationResult_ctx__SUCCESS;
    }
    else
    {
        (*weight) = 1;
        (*res) = OperationResult_ctx__ERROR;
    }
}

void PeopleInfo__peopleinfo_set_weight(int32_t user, int32_t weight, OperationResult_ctx__OPERATION_RESULT *res)
{
    if((((user) >= (0)) &&
        ((user) <= (People_ctx__PEOPLE_LIMIT))) &&
    ((weight) > (0)))
    {
        PeopleInfo__people_weight[user] = weight;
        (*res) = OperationResult_ctx__SUCCESS;
    }
    else
    {
        (*res) = OperationResult_ctx__ERROR;
    }
}

