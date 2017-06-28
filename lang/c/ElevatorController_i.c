/* WARNING if type checker is not performed, translation could contain errors ! */

#include "ElevatorController.h"

/* Clause SEES */
#include "Elevator_ctx.h"
#include "People_ctx.h"
#include "OperationResult_ctx.h"

/* Clause IMPORTS */
#include "IdChecker.h"
#include "PeopleInfo.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

/* Array and record constants */
/* Clause CONCRETE_VARIABLES */

static int32_t ElevatorController__current_floor_i[Elevator_ctx__ELEVATOR_LIMIT+1];
static int32_t ElevatorController__elevator_weight_i[Elevator_ctx__ELEVATOR_LIMIT+1];
static Elevator_ctx__DOOR_STATE ElevatorController__internal_door_state_i[Elevator_ctx__ELEVATOR_LIMIT+1];
static Elevator_ctx__DOOR_STATE ElevatorController__floor_door_state_i[Elevator_ctx__TOP_FLOOR+1][Elevator_ctx__ELEVATOR_LIMIT+1];
static bool ElevatorController__elevator_people_i[Elevator_ctx__ELEVATOR_LIMIT+1][People_ctx__PEOPLE_LIMIT+1];
static bool ElevatorController__choosen_elevator_i[People_ctx__PEOPLE_LIMIT+1][Elevator_ctx__ELEVATOR_LIMIT+1];
static bool ElevatorController__origin_floor_i[People_ctx__PEOPLE_LIMIT+1][Elevator_ctx__TOP_FLOOR+1];
static bool ElevatorController__destination_floor_i[People_ctx__PEOPLE_LIMIT+1][Elevator_ctx__TOP_FLOOR+1];
static int32_t ElevatorController__elevator_floor_sequence_i[Elevator_ctx__ELEVATOR_LIMIT+1];
static int32_t ElevatorController__elevator_floor_sequence_start_i[Elevator_ctx__ELEVATOR_LIMIT+1];
static int32_t ElevatorController__elevator_floor_sequence_end_i[Elevator_ctx__ELEVATOR_LIMIT+1];
static int32_t ElevatorController__elevator_floor_sequence_size_i[Elevator_ctx__ELEVATOR_LIMIT+1];
/* Clause INITIALISATION */
void ElevatorController__INITIALISATION(void)
{
    
    unsigned int i = 0, j= 0;
    IdChecker__INITIALISATION();
    PeopleInfo__INITIALISATION();
    for(i = 0; i <= Elevator_ctx__ELEVATOR_LIMIT;i++)
    {
        ElevatorController__current_floor_i[i] = Elevator_ctx__GROUND_FLOOR;
    }
    for(i = 0; i <= Elevator_ctx__ELEVATOR_LIMIT;i++)
    {
        ElevatorController__elevator_weight_i[i] = 0;
    }
    for(i = 0; i <= Elevator_ctx__ELEVATOR_LIMIT;i++)
    {
        ElevatorController__internal_door_state_i[i] = Elevator_ctx__CLOSED;
    }
    for(i = 0; i <= Elevator_ctx__TOP_FLOOR;i++)
    {
        for(j = 0; j <= Elevator_ctx__ELEVATOR_LIMIT;j++)
        {
            ElevatorController__floor_door_state_i[i][j] = Elevator_ctx__CLOSED;
        }
    }
    for(i = 0; i <= Elevator_ctx__ELEVATOR_LIMIT;i++)
    {
        for(j = 0; j <= People_ctx__PEOPLE_LIMIT;j++)
        {
            ElevatorController__elevator_people_i[i][j] = false;
        }
    }
    for(i = 0; i <= People_ctx__PEOPLE_LIMIT;i++)
    {
        for(j = 0; j <= Elevator_ctx__ELEVATOR_LIMIT;j++)
        {
            ElevatorController__choosen_elevator_i[i][j] = false;
        }
    }
    for(i = 0; i <= People_ctx__PEOPLE_LIMIT;i++)
    {
        for(j = 0; j <= Elevator_ctx__TOP_FLOOR;j++)
        {
            ElevatorController__origin_floor_i[i][j] = false;
        }
    }
    for(i = 0; i <= People_ctx__PEOPLE_LIMIT;i++)
    {
        for(j = 0; j <= Elevator_ctx__TOP_FLOOR;j++)
        {
            ElevatorController__destination_floor_i[i][j] = false;
        }
    }
    for(i = 0; i <= Elevator_ctx__ELEVATOR_LIMIT;i++)
    {
        ElevatorController__elevator_floor_sequence_i[i] = Elevator_ctx__GROUND_FLOOR;
    }
    for(i = 0; i <= Elevator_ctx__ELEVATOR_LIMIT;i++)
    {
        ElevatorController__elevator_floor_sequence_start_i[i] = 0;
    }
    for(i = 0; i <= Elevator_ctx__ELEVATOR_LIMIT;i++)
    {
        ElevatorController__elevator_floor_sequence_end_i[i] = 0;
    }
    for(i = 0; i <= Elevator_ctx__ELEVATOR_LIMIT;i++)
    {
        ElevatorController__elevator_floor_sequence_size_i[i] = 0;
    }
}

/* Clause OPERATIONS */

void ElevatorController__elev_current_floor(int32_t ee, int32_t *ff, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((ee) >= (0)) &&
    ((ee) <= (Elevator_ctx__ELEVATOR_LIMIT)))
    {
        (*ff) = ElevatorController__current_floor_i[ee];
        (*res) = OperationResult_ctx__SUCCESS;
    }
    else
    {
        (*ff) = 0;
        (*res) = OperationResult_ctx__ERROR;
    }
}

void ElevatorController__elev_current_weight(int32_t ee, int32_t *ww, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((ee) >= (0)) &&
    ((ee) <= (Elevator_ctx__ELEVATOR_LIMIT)))
    {
        (*ww) = ElevatorController__elevator_weight_i[ee];
        (*res) = OperationResult_ctx__SUCCESS;
    }
    else
    {
        (*ww) = 0;
        (*res) = OperationResult_ctx__ERROR;
    }
}

void ElevatorController__elev_door_state(int32_t ee, Elevator_ctx__DOOR_STATE *ss, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((ee) >= (0)) &&
    ((ee) <= (Elevator_ctx__ELEVATOR_LIMIT)))
    {
        (*ss) = ElevatorController__internal_door_state_i[ee];
        (*res) = OperationResult_ctx__SUCCESS;
    }
    else
    {
        (*ss) = Elevator_ctx__OPEN;
        (*res) = OperationResult_ctx__ERROR;
    }
}

void ElevatorController__elev_direction(int32_t ee, Elevator_ctx__DIRECTION *dir, Elevator_ctx__STATE *state, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((ee) >= (0)) &&
    ((ee) <= (Elevator_ctx__ELEVATOR_LIMIT)))
    {
        {
            int32_t sz;
            
            sz = ElevatorController__elevator_floor_sequence_size_i[ee];
            if((sz) > (0))
            {
                {
                    int32_t ss;
                    int32_t ff;
                    int32_t st;
                    
                    ss = ElevatorController__elevator_floor_sequence_start_i[ee];
                    ff = ElevatorController__current_floor_i[ee];
                    st = ElevatorController__elevator_floor_sequence_i[ss];
                    if((ff) > (st))
                    {
                        (*dir) = Elevator_ctx__DOWN;
                    }
                    else if((ff) < (st))
                    {
                        (*dir) = Elevator_ctx__UP;
                    }
                    else
                    {
                        (*dir) = Elevator_ctx__NONE;
                    }
                    (*state) = Elevator_ctx__ATTENDING;
                }
            }
            else
            {
                (*dir) = Elevator_ctx__NONE;
                (*state) = Elevator_ctx__FREE;
            }
            (*res) = OperationResult_ctx__SUCCESS;
        }
    }
    else
    {
        (*dir) = Elevator_ctx__NONE;
        (*state) = Elevator_ctx__ATTENDING;
        (*res) = OperationResult_ctx__ERROR;
    }
}

void ElevatorController__elev_call_elevator(int32_t user, int32_t call_floor, int32_t dest_floor, int32_t *elnum, OperationResult_ctx__OPERATION_RESULT *res)
{
    if((((((((call_floor) >= (0)) &&
                        ((call_floor) <= (Elevator_ctx__TOP_FLOOR))) &&
                    ((dest_floor) >= (0))) &&
                ((dest_floor) <= (Elevator_ctx__TOP_FLOOR))) &&
            ((user) >= (0))) &&
        ((user) <= (People_ctx__PEOPLE_LIMIT))) &&
    ((call_floor) != (dest_floor)))
    {
        (*elnum) = 0;
        (*res) = OperationResult_ctx__SUCCESS;
    }
    else
    {
        (*elnum) = 0;
        (*res) = OperationResult_ctx__ERROR;
    }
}

void ElevatorController__elev_open_door(int32_t ee, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res)
{
    {
        Elevator_ctx__DOOR_STATE ids;
        Elevator_ctx__DOOR_STATE fds;
        int32_t cur_ff;
        
        ids = ElevatorController__internal_door_state_i[ee];
        fds = ElevatorController__floor_door_state_i[ff][ee];
        cur_ff = ElevatorController__current_floor_i[ee];
        if((((((((ee) >= (0)) &&
                            ((ee) <= (Elevator_ctx__ELEVATOR_LIMIT))) &&
                        ((ff) >= (0))) &&
                    ((ff) <= (Elevator_ctx__TOP_FLOOR))) &&
                (ids == Elevator_ctx__CLOSED)) &&
            (fds == Elevator_ctx__CLOSED)) &&
        (cur_ff == ff))
        {
            ElevatorController__internal_door_state_i[ee] = Elevator_ctx__OPEN;
            ElevatorController__floor_door_state_i[ff][ee] = Elevator_ctx__OPEN;
            (*res) = OperationResult_ctx__SUCCESS;
        }
        else
        {
            (*res) = OperationResult_ctx__ERROR;
        }
    }
}

void ElevatorController__elev_close_door(int32_t ee, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res)
{
    {
        Elevator_ctx__DOOR_STATE ids;
        Elevator_ctx__DOOR_STATE fds;
        int32_t cur_ff;
        int32_t ew;
        
        ids = ElevatorController__internal_door_state_i[ee];
        fds = ElevatorController__floor_door_state_i[ff][ee];
        cur_ff = ElevatorController__current_floor_i[ee];
        ew = ElevatorController__elevator_weight_i[ee];
        if(((((((((ee) >= (0)) &&
                                ((ee) <= (Elevator_ctx__ELEVATOR_LIMIT))) &&
                            ((ff) >= (0))) &&
                        ((ff) <= (Elevator_ctx__TOP_FLOOR))) &&
                    (ids == Elevator_ctx__OPEN)) &&
                (fds == Elevator_ctx__OPEN)) &&
            (cur_ff == ff)) &&
        ((ew) <= (Elevator_ctx__WEIGHT_LIMIT)))
        {
            ElevatorController__internal_door_state_i[ee] = Elevator_ctx__CLOSED;
            ElevatorController__floor_door_state_i[ff][ee] = Elevator_ctx__CLOSED;
            {
                int32_t ss;
                int32_t cur_ff;
                int32_t st;
                int32_t sz;
                
                ss = ElevatorController__elevator_floor_sequence_start_i[ee];
                cur_ff = ElevatorController__current_floor_i[ee];
                st = ElevatorController__elevator_floor_sequence_i[ss];
                sz = ElevatorController__elevator_floor_sequence_size_i[ee];
                if(cur_ff == st)
                {
                    {
                        int32_t ii;
                        
                        ii = st+1;
                        ElevatorController__elevator_floor_sequence_start_i[ee] = ii % Elevator_ctx__ELEVATOR_LIMIT;
                        ElevatorController__elevator_floor_sequence_size_i[ee] = sz+1;
                    }
                }
            }
            (*res) = OperationResult_ctx__SUCCESS;
        }
        else
        {
            (*res) = OperationResult_ctx__ERROR;
        }
    }
}

void ElevatorController__elev_enter(int32_t uu, int32_t ee, OperationResult_ctx__OPERATION_RESULT *res)
{
    {
        int32_t ff;
        int32_t ew;
        int32_t pw;
        OperationResult_ctx__OPERATION_RESULT rr;
        Elevator_ctx__DOOR_STATE ids;
        Elevator_ctx__DOOR_STATE fds;
        bool ep;
        int32_t w_sum;
        bool ch_elev;
        bool or_ff;
        
        ff = ElevatorController__current_floor_i[ee];
        ew = ElevatorController__elevator_weight_i[ee];
        PeopleInfo__peopleinfo_query_weight(uu, &pw, &rr);
        ids = ElevatorController__internal_door_state_i[ee];
        fds = ElevatorController__floor_door_state_i[ff][ee];
        ep = ElevatorController__elevator_people_i[ee][uu];
        w_sum = ew+pw;
        ch_elev = ElevatorController__choosen_elevator_i[uu][ee];
        or_ff = ElevatorController__origin_floor_i[uu][ff];
        if(((((((((((ee) >= (0)) &&
                                        ((ee) <= (Elevator_ctx__ELEVATOR_LIMIT))) &&
                                    ((uu) >= (0))) &&
                                ((uu) <= (People_ctx__PEOPLE_LIMIT))) &&
                            (ids == Elevator_ctx__OPEN)) &&
                        (fds == Elevator_ctx__OPEN)) &&
                    (ep == false)) &&
                ((w_sum) <= (Elevator_ctx__WEIGHT_LIMIT))) &&
            (ch_elev == true)) &&
        (or_ff == true))
        {
            ElevatorController__elevator_people_i[ee][uu] = true;
            ElevatorController__elevator_weight_i[ee] = ew+pw;
            ElevatorController__choosen_elevator_i[uu][ee] = false;
            ElevatorController__origin_floor_i[uu][ff] = false;
            (*res) = OperationResult_ctx__SUCCESS;
        }
        else
        {
            (*res) = OperationResult_ctx__ERROR;
        }
    }
}

void ElevatorController__elev_exit(int32_t uu, int32_t ee, OperationResult_ctx__OPERATION_RESULT *res)
{
    {
        int32_t ff;
        int32_t ew;
        int32_t pw;
        OperationResult_ctx__OPERATION_RESULT rr;
        Elevator_ctx__DOOR_STATE ids;
        Elevator_ctx__DOOR_STATE fds;
        bool ep;
        bool dest_ff;
        
        ff = ElevatorController__current_floor_i[ee];
        ew = ElevatorController__elevator_weight_i[ee];
        PeopleInfo__peopleinfo_query_weight(uu, &pw, &rr);
        ids = ElevatorController__internal_door_state_i[ee];
        fds = ElevatorController__floor_door_state_i[ff][ee];
        ep = ElevatorController__elevator_people_i[ee][uu];
        dest_ff = ElevatorController__destination_floor_i[uu][ff];
        if(((((((((ee) >= (0)) &&
                                ((ee) <= (Elevator_ctx__ELEVATOR_LIMIT))) &&
                            ((uu) >= (0))) &&
                        ((uu) <= (People_ctx__PEOPLE_LIMIT))) &&
                    (ids == Elevator_ctx__OPEN)) &&
                (fds == Elevator_ctx__OPEN)) &&
            (ep == true)) &&
        (dest_ff == true))
        {
            ElevatorController__elevator_people_i[ee][uu] = false;
            ElevatorController__elevator_weight_i[ee] = ew-pw;
            ElevatorController__destination_floor_i[uu][ff] = false;
            (*res) = OperationResult_ctx__SUCCESS;
        }
        else
        {
            (*res) = OperationResult_ctx__ERROR;
        }
    }
}

void ElevatorController__elev_go_up(int32_t ee, OperationResult_ctx__OPERATION_RESULT *res)
{
    {
        int32_t ss;
        int32_t ff;
        int32_t sz;
        int32_t cur_ff;
        int32_t st;
        Elevator_ctx__DOOR_STATE ids;
        Elevator_ctx__DOOR_STATE fds;
        
        ss = ElevatorController__elevator_floor_sequence_start_i[ee];
        ff = ElevatorController__current_floor_i[ee];
        sz = ElevatorController__elevator_floor_sequence_size_i[ee];
        cur_ff = ElevatorController__current_floor_i[ee];
        st = ElevatorController__elevator_floor_sequence_i[ss];
        ids = ElevatorController__internal_door_state_i[ee];
        fds = ElevatorController__floor_door_state_i[ff][ee];
        if((((((((ee) >= (0)) &&
                            ((ee) <= (Elevator_ctx__ELEVATOR_LIMIT))) &&
                        ((sz) > (0))) &&
                    ((cur_ff) < (st))) &&
                ((cur_ff) < (Elevator_ctx__TOP_FLOOR))) &&
            (ids == Elevator_ctx__CLOSED)) &&
        (fds == Elevator_ctx__CLOSED))
        {
            ElevatorController__current_floor_i[ee] = ff+1;
            (*res) = OperationResult_ctx__SUCCESS;
        }
        else
        {
            (*res) = OperationResult_ctx__ERROR;
        }
    }
}

void ElevatorController__elev_go_down(int32_t ee, OperationResult_ctx__OPERATION_RESULT *res)
{
    {
        int32_t ss;
        int32_t ff;
        int32_t sz;
        int32_t st;
        int32_t cur_ff;
        Elevator_ctx__DOOR_STATE ids;
        Elevator_ctx__DOOR_STATE fds;
        
        ss = ElevatorController__elevator_floor_sequence_start_i[ee];
        ff = ElevatorController__current_floor_i[ee];
        sz = ElevatorController__elevator_floor_sequence_size_i[ee];
        cur_ff = ElevatorController__current_floor_i[ee];
        st = ElevatorController__elevator_floor_sequence_i[ss];
        ids = ElevatorController__internal_door_state_i[ee];
        fds = ElevatorController__floor_door_state_i[ff][ee];
        if((((((((ee) >= (0)) &&
                            ((ee) <= (Elevator_ctx__ELEVATOR_LIMIT))) &&
                        ((sz) > (0))) &&
                    ((cur_ff) > (st))) &&
                ((cur_ff) > (Elevator_ctx__GROUND_FLOOR))) &&
            (ids == Elevator_ctx__CLOSED)) &&
        (fds == Elevator_ctx__CLOSED))
        {
            ElevatorController__current_floor_i[ee] = ff-1;
            (*res) = OperationResult_ctx__SUCCESS;
        }
        else
        {
            (*res) = OperationResult_ctx__ERROR;
        }
    }
}

void ElevatorController__peopleinfo_set_weight_roubust(int32_t uu, int32_t ww, OperationResult_ctx__OPERATION_RESULT *res)
{
    if((((uu) >= (0)) &&
        ((uu) <= (People_ctx__PEOPLE_LIMIT))) &&
    ((ww) > (0)))
    {
        PeopleInfo__peopleinfo_set_weight(uu, ww, res);
    }
    else
    {
        (*res) = OperationResult_ctx__ERROR;
    }
}

void ElevatorController__idchecker_authorize_floor_robust(int32_t uu, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((((uu) >= (0)) &&
            ((uu) <= (People_ctx__PEOPLE_LIMIT))) &&
        ((ff) >= (0))) &&
    ((ff) <= (Elevator_ctx__TOP_FLOOR)))
    {
        IdChecker__idchecker_authorize_floor(uu, ff, res);
    }
    else
    {
        (*res) = OperationResult_ctx__ERROR;
    }
}

void ElevatorController__idchecker_revoke_floor_robust(int32_t uu, int32_t ff, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((((uu) >= (0)) &&
            ((uu) <= (People_ctx__PEOPLE_LIMIT))) &&
        ((ff) >= (0))) &&
    ((ff) <= (Elevator_ctx__TOP_FLOOR)))
    {
        IdChecker__idchecker_revoke_floor(uu, ff, res);
    }
    else
    {
        (*res) = OperationResult_ctx__ERROR;
    }
}

void ElevatorController__idchecker_revoke_all_robust(int32_t uu, OperationResult_ctx__OPERATION_RESULT *res)
{
    if(((uu) >= (0)) &&
    ((uu) <= (People_ctx__PEOPLE_LIMIT)))
    {
        IdChecker__idchecker_revoke_all(uu, res);
    }
    else
    {
        (*res) = OperationResult_ctx__ERROR;
    }
}

