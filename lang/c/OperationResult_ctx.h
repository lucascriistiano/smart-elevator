#ifndef _OperationResult_ctx_h
#define _OperationResult_ctx_h

#include <stdint.h>
#include <stdbool.h>
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */
typedef enum
{
    OperationResult_ctx__SUCCESS,
    OperationResult_ctx__ERROR
    
} OperationResult_ctx__OPERATION_RESULT;
#define OperationResult_ctx__OPERATION_RESULT__max 2

/* Clause CONCRETE_VARIABLES */


/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
/* Array and record constants */
extern void OperationResult_ctx__INITIALISATION(void);


#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _OperationResult_ctx_h */
