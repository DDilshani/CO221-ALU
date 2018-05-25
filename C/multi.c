
#include <stdlib.h>
#include <stdio.h>

void printBinary(int b, int l){

	for(int i=l-1;i>=0;i--){
		printf("%d", (b>>i & 1));
	}
	return;
}


int main(){

	printf(" %c  ", 'x');
	for(int j=0;j<16;j++){
		printf(" ");
		printBinary(j, 4);
		printf("  ");
	}
	printf("\n----------------------------------------------------------\n");
	
	for(int i=0;i<16;i++){
		printf(" %d  ", i);
		
		for(int j=0;j<16;j++){
			printf(" ");
			printBinary(i*j, 4);
			printf("  ");
		}
		printf("\n");
	}

	return 0;
}