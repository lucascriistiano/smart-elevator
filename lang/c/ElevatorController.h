#ifndef _ElevatorController_h
#define _ElevatorController_h

#include <stdint.h>
#include <stdbool.h>
/* Clause SEES */
#include "Elevator_ctx.h"
#include "People_ctx.h"

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

extern void ElevatorController__elev_current_floor(int32_t ee, int32_t *ff);
extern void ElevatorController__elev_current_weight(int32_t ee, int32_t *ww);
extern void ElevatorController__elev_door_state(int32_t ee, Elevator_ctx__DOOR_STATE *ss);
extern void ElevatorController__elev_direction(int32_t ee, Elevator_ctx__DIRECTION *dir);
extern void ElevatorController__elev_call_elevator(int32_t call_floor, int32_t dest_floor, int32_t user, int32_t *elnum);
extern void ElevatorController__elev_open_door(int32_t ee, int32_t ff);
extern void ElevatorController__elev_close_door(int32_t ee, int32_t ff);
extern void ElevatorController__elev_enter(int32_t ee, int32_t uu);
extern void ElevatorController__elev_exit(int32_t ee, int32_t uu);
extern void ElevatorController__elev_go_up(int32_t ee);
extern void ElevatorController__elev_go_down(int32_t ee);

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _ElevatorController_h */
