#ifndef _IdChecker_ctx_h
#define _IdChecker_ctx_h

#include <stdint.h>
#include <stdbool.h>
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */
typedef enum
{
    IdChecker_ctx__AUTHORIZED,
    IdChecker_ctx__NOT_AUTHORIZED
    
} IdChecker_ctx__RESULT;
#define IdChecker_ctx__RESULT__max 2

/* Clause CONCRETE_VARIABLES */


/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
/* Array and record constants */
extern void IdChecker_ctx__INITIALISATION(void);


#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _IdChecker_ctx_h */
