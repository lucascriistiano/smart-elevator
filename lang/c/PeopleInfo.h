#ifndef _PeopleInfo_h
#define _PeopleInfo_h

#include <stdint.h>
#include <stdbool.h>
/* Clause SEES */
#include "People_ctx.h"
#include "OperationResult_ctx.h"

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */

/* Clause CONCRETE_VARIABLES */


/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
/* Array and record constants */
extern void PeopleInfo__INITIALISATION(void);

/* Clause OPERATIONS */

extern void PeopleInfo__peopleinfo_query_weight(int32_t user, int32_t *weight, OperationResult_ctx__OPERATION_RESULT *res);
extern void PeopleInfo__peopleinfo_set_weight(int32_t user, int32_t weight, OperationResult_ctx__OPERATION_RESULT *res);

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _PeopleInfo_h */
