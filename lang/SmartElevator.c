#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "c/ElevatorController.h"
#include "c/PeopleInfo.h"
#include "c/OperationResult_ctx.h"
#include "c/IdChecker.h"
#include "c/IdChecker_ctx.h"

#define OP_ELEVATOR_CURRENT_FLOOR 	1
#define OP_ELEVATOR_CURRENT_WEIGHT 	2
#define OP_ELEVATOR_DOOR_STATE 		3
#define OP_ELEVATOR_DIRECTION 		4
#define OP_ELEVATOR_CALL_ELEVATOR 	5
#define OP_ELEVATOR_OPEN_DOOR 		6
#define OP_ELEVATOR_CLOSE_DOOR 		7
#define OP_ELEVATOR_ENTER 			8
#define OP_ELEVATOR_EXIT 			9
#define OP_ELEVATOR_GO_UP 			10
#define OP_ELEVATOR_GO_DOWN 		11

#define OP_IDCHECKER_CHECK_FLOOR_AUTH	12
#define OP_IDCHECKER_AUTHORIZE_FLOOR	13
#define OP_IDCHECKER_REVOKE_FLOOR		14
#define OP_IDCHECKER_REVOKE_ALL			15

#define OP_PEOPLEINFO_QUERY_WEIGHT 	16
#define OP_PEOPLEINFO_SET_WEIGHT	17

#define OP_QUIT_PROGRAM 			0

void print_menu(){
	system("@cls || clear");
	printf("----- SMART ELEVATOR -----\n");
	printf("----- Elevator Operations -----\n");
	printf("----- Query Operations -----\n");
	printf("%2d. Current floor\n", OP_ELEVATOR_CURRENT_FLOOR);
	printf("%2d. Current weight\n", OP_ELEVATOR_CURRENT_WEIGHT);
	printf("%2d. Door state\n", OP_ELEVATOR_DOOR_STATE);
	printf("%2d. Direction\n", OP_ELEVATOR_DIRECTION);
	printf("----- Actions -----\n");
	printf("%2d. Call elevator\n", OP_ELEVATOR_CALL_ELEVATOR);
	printf("%2d. Open door\n", OP_ELEVATOR_OPEN_DOOR);
	printf("%2d. Close door\n", OP_ELEVATOR_CLOSE_DOOR);
	printf("%2d. Enter elevator\n", OP_ELEVATOR_ENTER);
	printf("%2d. Exit elevator\n", OP_ELEVATOR_EXIT);
	printf("%2d. Go up\n", OP_ELEVATOR_GO_UP);
	printf("%2d. Go down\n", OP_ELEVATOR_GO_DOWN);
	printf("\n");

	printf("----- Authorization Operations -----\n");
	printf("----- Query Operations -----\n");
	printf("%2d. Check floor authorization\n", OP_IDCHECKER_CHECK_FLOOR_AUTH);
	printf("----- Actions -----\n");
	printf("%2d. Authorize floor\n", OP_IDCHECKER_AUTHORIZE_FLOOR);
	printf("%2d. Revoke floor\n", OP_IDCHECKER_REVOKE_FLOOR);
	printf("%2d. Revoke all\n", OP_IDCHECKER_REVOKE_ALL);
	printf("\n");

	printf("----- People Info Operations -----\n");
	printf("----- Query Operations -----\n");
	printf("%2d. Query people weight\n", OP_PEOPLEINFO_QUERY_WEIGHT);
	printf("----- Actions -----\n");
	printf("%2d. Set people weight\n", OP_PEOPLEINFO_SET_WEIGHT);
	printf("\n");

	printf("%2d. Quit Program\n", OP_QUIT_PROGRAM);
	printf("----- SMART ELEVATOR -----\n");	
}

int main() {
	print_menu();

	ElevatorController__INITIALISATION();
	PeopleInfo__INITIALISATION();
	IdChecker__INITIALISATION();

	int op;
	while(true){
		printf("Operation: ");
		scanf("%d", &op);
		
		print_menu();

		if(op == OP_ELEVATOR_CURRENT_FLOOR) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t ee, ff;

			printf("Elevator ID: ");
			scanf("%d", &ee);

			ElevatorController__elev_current_floor(ee, &ff, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Elevator %d current floor is %d\n", ee, ff);
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_ELEVATOR_CURRENT_WEIGHT) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t ee, ww;

			printf("Elevator ID: ");
			scanf("%d", &ee);
			
			ElevatorController__elev_current_weight(ee, &ww, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Elevator %d current weight is %d\n", ee, ww);
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_ELEVATOR_DOOR_STATE) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t ee;
			Elevator_ctx__DOOR_STATE ss;

			printf("Elevator ID: ");
			scanf("%d", &ee);

			ElevatorController__elev_door_state(ee, &ss, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Elevator %d door is ", ee);
				if(ss == Elevator_ctx__OPEN) {
					printf("OPEN\n");
				} else {
					printf("CLOSED\n");
				}
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_ELEVATOR_DIRECTION) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t ee;
			Elevator_ctx__DIRECTION dir;
			Elevator_ctx__STATE state;

			printf("Elevator ID: ");
			scanf("%d", &ee);

			ElevatorController__elev_direction(ee, &dir, &state, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Elevator %d direction is:\n", ee);
				printf("STATE: ");
				if(state == Elevator_ctx__FREE) {
					printf("FREE\n");
				} else {
					printf("ATTENDING\n");
				}
				
				printf("DIRECTION: ");
				if(dir == Elevator_ctx__UP) {
					printf("UP\n");
				} else if(dir == Elevator_ctx__DOWN) {
					printf("DOWN\n");
				} else {
					printf("NONE\n");
				}

				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_ELEVATOR_CALL_ELEVATOR) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t uu, call_floor, dest_floor, elnum;

			printf("User ID: ");
			scanf("%d", &uu);

			printf("Call floor ID: ");
			scanf("%d", &call_floor);

			printf("Destination floor ID: ");
			scanf("%d", &dest_floor);

			ElevatorController__elev_call_elevator(uu, call_floor, dest_floor, &elnum, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Selected elevator %d for user %d from floor %d to floor %d.\n", elnum, uu, call_floor, dest_floor);
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_ELEVATOR_OPEN_DOOR) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t ee, ff;

			printf("Elevator ID: ");
			scanf("%d", &ee);

			printf("Floor ID: ");
			scanf("%d", &ff);

			ElevatorController__elev_open_door(ee, ff, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if (op == OP_ELEVATOR_CLOSE_DOOR) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t ee, ff;

			printf("Elevator ID: ");
			scanf("%d", &ee);

			printf("Floor ID: ");
			scanf("%d", &ff);

			ElevatorController__elev_close_door(ee, ff, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_ELEVATOR_ENTER) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t uu, ee;

			printf("User ID: ");
			scanf("%d", &uu);

			printf("Elevator ID: ");
			scanf("%d", &ee);

			ElevatorController__elev_enter(uu, ee, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_ELEVATOR_EXIT) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t uu, ee;

			printf("User ID: ");
			scanf("%d", &uu);

			printf("Elevator ID: ");
			scanf("%d", &ee);

			ElevatorController__elev_exit(uu, ee, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_ELEVATOR_GO_UP) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t ee;

			printf("Elevator ID: ");
			scanf("%d", &ee);

			ElevatorController__elev_go_up(ee, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_ELEVATOR_GO_DOWN) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t ee;

			printf("Elevator ID: ");
			scanf("%d", &ee);

			ElevatorController__elev_go_down(ee, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_IDCHECKER_CHECK_FLOOR_AUTH) {
			IdChecker_ctx__RESULT auth;
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t uu, ff;
			
			printf("User ID: ");
			scanf("%d", &uu);

			printf("Floor: ");
			scanf("%d", &ff);

			IdChecker__idchecker_check_floor_authorization(uu, ff, &auth, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				if(auth == IdChecker_ctx__AUTHORIZED) {
					printf("User %d is AUTHORIZED to floor %d\n", uu, ff);
				} else {
					printf("User %d is NOT AUTHORIZED to floor %d\n", uu, ff);
				}
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_IDCHECKER_AUTHORIZE_FLOOR) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t uu, ff;
			
			printf("User ID: ");
			scanf("%d", &uu);

			printf("Floor: ");
			scanf("%d", &ff);

			//IdChecker__idchecker_authorize_floor(uu, ff, &res);
			ElevatorController__idchecker_authorize_floor_robust(uu, ff, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_IDCHECKER_REVOKE_FLOOR) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t uu, ff;
			
			printf("User ID: ");
			scanf("%d", &uu);

			printf("Floor: ");
			scanf("%d", &ff);

			//IdChecker__idchecker_revoke_floor(uu, ff, &res);
			ElevatorController__idchecker_revoke_floor_robust(uu, ff, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_IDCHECKER_REVOKE_ALL) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t uu, ff;
			
			printf("User ID: ");
			scanf("%d", &uu);

			//IdChecker__idchecker_revoke_all(uu, &res);
			ElevatorController__idchecker_revoke_all_robust(uu, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_PEOPLEINFO_QUERY_WEIGHT) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t uu, ww;
			
			printf("User ID: ");
			scanf("%d", &uu);

			PeopleInfo__peopleinfo_query_weight(uu, &ww, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Weight of user %d is %d\n", uu, ww);
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_PEOPLEINFO_SET_WEIGHT) {
			OperationResult_ctx__OPERATION_RESULT res;
			int32_t uu, ww;

			printf("User ID: ");
			scanf("%d", &uu);

			printf("Weight: ");
			scanf("%d", &ww);

			//PeopleInfo__peopleinfo_set_weight(uu, ww, &res);
			ElevatorController__peopleinfo_set_weight_roubust(uu, ww, &res);

			if(res == OperationResult_ctx__SUCCESS) {
				printf("Operation successfully finished.\n");
			} else {
				printf("Error while running the operation.\n");
			}

		} else if(op == OP_QUIT_PROGRAM) {
			printf("Bye bye.\n");
			system("@cls || clear");
			return EXIT_SUCCESS;

		} else {
			printf("Unknown operation. Try again.\n");
		}
		printf("----- SMART ELEVATOR -----\n");	
	}

	system("@cls || clear");
	return EXIT_SUCCESS;
}