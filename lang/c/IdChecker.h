#ifndef _IdChecker_h
#define _IdChecker_h

#include <stdint.h>
#include <stdbool.h>
/* Clause SEES */
#include "People_ctx.h"
#include "Elevator_ctx.h"
#include "IdChecker_ctx.h"
#include "OperationResult_ctx.h"

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */

/* Clause CONCRETE_VARIABLES */


/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
/* Array and record constants */
extern void IdChecker__INITIALISATION(void);

/* Clause OPERATIONS */

extern void IdChecker__idchecker_check_floor_authorization(int32_t uu, int32_t ff, IdChecker_ctx__RESULT *auth, OperationResult_ctx__OPERATION_RESULT *res);
extern void IdChecker__idchecker_authorize_floor(int32_t uu, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res);
extern void IdChecker__idchecker_revoke_floor(int32_t uu, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res);
extern void IdChecker__idchecker_revoke_all(int32_t uu, OperationResult_ctx__OPERATION_RESULT *res);

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _IdChecker_h */
