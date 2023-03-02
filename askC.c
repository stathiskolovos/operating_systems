#include <stdio.h>
#include <stdlib.h>



int main(){
    int pid;
    for (int i=0; i<5; i++) 
    {
        pid = fork();
        if (pid == -1){//Αν είναι αρνητικό η fork() failed
            printf("Error!\n");
            return 0;
        }
        else if (pid == 0) {//Για τις θυγατρικές
            printf("My parent's id is %d. My id is %d. My child's id is %d\n", getppid(), getpid(), getpid()+1);
        	//το id του παιδιού της είναι το αμέσως επόμενο.
		}
        else { //Αν η fork() > 0 αναφερόμαστε στον πατέρα.
        wait();//Αναμονή για τις θυγατρικές
        exit(0);//τέλος εκτέλεσης
        }
    }
}
