#ifndef _ElevatorController_h
#define _ElevatorController_h

#include <stdint.h>
#include <stdbool.h>
/* Clause SEES */
#include "Elevator_ctx.h"
#include "People_ctx.h"
#include "OperationResult_ctx.h"

/* Clause INCLUDES */
#include "IdChecker.h"
#include "PeopleInfo.h"

/* Clause IMPORTS */
#include "IdChecker.h"
#include "PeopleInfo.h"
#define ElevatorController__idchecker_check_floor_authorization IdChecker__idchecker_check_floor_authorization
#define ElevatorController__peopleinfo_query_weight PeopleInfo__peopleinfo_query_weight

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */

/* Clause CONCRETE_VARIABLES */


/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
/* Array and record constants */
extern void ElevatorController__INITIALISATION(void);

/* Clause OPERATIONS */

extern void ElevatorController__elev_current_floor(int32_t ee, int32_t *ff, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__elev_current_weight(int32_t ee, int32_t *ww, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__elev_door_state(int32_t ee, Elevator_ctx__DOOR_STATE *ss, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__elev_direction(int32_t ee, Elevator_ctx__DIRECTION *dir, Elevator_ctx__STATE *state, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__elev_call_elevator(int32_t user, int32_t call_floor, int32_t dest_floor, int32_t *elnum, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__elev_open_door(int32_t ee, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__elev_close_door(int32_t ee, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__elev_enter(int32_t uu, int32_t ee, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__elev_exit(int32_t uu, int32_t ee, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__elev_go_up(int32_t ee, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__elev_go_down(int32_t ee, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__peopleinfo_set_weight_roubust(int32_t uu, int32_t ww, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__idchecker_authorize_floor_robust(int32_t uu, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__idchecker_revoke_floor_robust(int32_t uu, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res);
extern void ElevatorController__idchecker_revoke_all_robust(int32_t uu, OperationResult_ctx__OPERATION_RESULT *res);

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _ElevatorController_h */
