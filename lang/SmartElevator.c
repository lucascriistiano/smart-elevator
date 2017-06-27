#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "c/ElevatorController.h"

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
#define OP_QUIT_PROGRAM 			12

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
	//operations here
	printf("\n");


	printf("----- People Info Operations -----\n");
	//operations here
	printf("\n");

	printf("%2d. Quit Program\n", OP_QUIT_PROGRAM);
	printf("----- SMART ELEVATOR -----\n");	
}

int main() {
	print_menu();

	ElevatorController__INITIALISATION();

	int op;
	while(true){
		printf("Operation: ");
		scanf("%d", &op);
		
		print_menu();

		if(op == OP_ELEVATOR_CURRENT_FLOOR){
			
		} else if(op == OP_ELEVATOR_CURRENT_WEIGHT){
			
		} else if(op == OP_ELEVATOR_DOOR_STATE){
			
		} else if(op == OP_ELEVATOR_DIRECTION){
			
		} else if(op == OP_ELEVATOR_CALL_ELEVATOR){
			
		} else if(op == OP_ELEVATOR_OPEN_DOOR) {
			
		} else if (op == OP_ELEVATOR_CLOSE_DOOR){
			
		} else if(op == OP_ELEVATOR_ENTER){
			
		} else if(op == OP_ELEVATOR_EXIT){
			
		} else if(op == OP_ELEVATOR_GO_UP){

		} else if(op == OP_ELEVATOR_GO_DOWN){
			
		} else if(op == OP_QUIT_PROGRAM) {
			return EXIT_SUCCESS;
		} else {
			printf("Unknown operation. Try again.\n");
		}
		printf("----- SMART ELEVATOR -----\n");	
	}

	return EXIT_SUCCESS;
}