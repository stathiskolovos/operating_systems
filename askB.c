#include <stdio.h>
#include <stdlib.h>

int main(){
    
    //Εκτύπωση του id του πατέρα
    printf("Parent. Pid = %d\n", getpid());
        
    //For loop για την παραγωγή των θυγατρικών.
    for(int i=0; i<4; i++){
        if(fork() == 0){//για fork()==0 αναφερόμαστε στις θυγατρικές
            printf("Child's pid %d from Parent pid %d\n", getpid(), getppid());
            exit(0);//τέλος εκτέλεσης θυγατρικής.
        }
    }
    
    //For loop για να περιμένει ο πατέρας να εκτελεστούν οι θυγατρικές
    for(int i=0;i<4; i++){
        wait();
    }
}
