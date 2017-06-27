#ifndef _Elevator_ctx_h
#define _Elevator_ctx_h

#include <stdint.h>
#include <stdbool.h>
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */
typedef enum
{
    Elevator_ctx__OPEN,
    Elevator_ctx__CLOSED
    
} Elevator_ctx__DOOR_STATE;
#define Elevator_ctx__DOOR_STATE__max 2
typedef enum
{
    Elevator_ctx__STOPPED,
    Elevator_ctx__MOVING
    
} Elevator_ctx__STATE;
#define Elevator_ctx__STATE__max 2
typedef enum
{
    Elevator_ctx__UP,
    Elevator_ctx__DOWN
    
} Elevator_ctx__DIRECTION;
#define Elevator_ctx__DIRECTION__max 2

/* Clause CONCRETE_VARIABLES */


/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
#define Elevator_ctx__ELEVATOR 0Elevator_ctx__ELEVATOR_LIMIT
#define Elevator_ctx__ELEVATOR_LIMIT 2
#define Elevator_ctx__FLOOR Elevator_ctx__GROUND_FLOORElevator_ctx__TOP_FLOOR
#define Elevator_ctx__GROUND_FLOOR 0
#define Elevator_ctx__TOP_FLOOR 4
#define Elevator_ctx__WEIGHT_LIMIT 20
/* Array and record constants */






extern void Elevator_ctx__INITIALISATION(void);


#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _Elevator_ctx_h */
