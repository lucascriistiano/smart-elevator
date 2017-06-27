/* WARNING if type checker is not performed, translation could contain errors ! */

#include "PeopleInfo.h"

/* Clause SEES */
#include "People_ctx.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

/* Array and record constants */
/* Clause CONCRETE_VARIABLES */

static int32_t PeopleInfo__people_weight[5];
/* Clause INITIALISATION */
void PeopleInfo__INITIALISATION(void)
{
    
    unsigned int i = 0;
    {
        for(i = 0; i <= People_ctx__PEOPLE__max-1;i++)
        {
            PeopleInfo__people_weight[i] = 1;
        }
    }
}

/* Clause OPERATIONS */

void PeopleInfo__peopleinfo_set_weight(int32_t user, int32_t weight)
{
    if((weight) > (0))
    {
        PeopleInfo__people_weight[user] = weight;
    }
}

void PeopleInfo__peopleinfo_query_weight(int32_t user, int32_t *weight)
{
    (*weight) = PeopleInfo__people_weight[user];
}

