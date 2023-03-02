#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int times = 10000; //αριθμός θυγατρικών διεργασιών
int i = 0; // μετρητής για την εκτέλεση while loop

//Συνάρτηση που καλεί καθεμιά θυγατρική
nothing(){
    
    int x=0;
    x=x+1;
    
}

int main(){

        float avg =0; //Μέσος όρος εκτέλεσης
        int seconds = 0;  //Συνολική διάρκεια
    
    	 //Με την time παίρνουμε την ακριβή ώρα του συστήματος και
    	 //την βάζουμε στο start ως αρχική τιμή.
        time_t start;
        start = time(NULL);
        printf("Αρχική τιμή δευτερολέπτων %ld\n", start);
        
        //While loop για παραγωγή θυγατρικών
        while( i < times){
            i++;
            if(fork() == 0){
                nothing();
                exit(0);
            }
        }
        
        //Ο πατέρας περιμένει για να εκτελεστούν οι θυγατρικές με επιτυχία
        while(i<times){
            i++;
            waitpid(-1,NULL,0);
        }
        
         //Με την time παίρνουμε την ακριβή ώρα του συστήματος και
    	 //την βάζουμε στο end ως τελική τιμή.
        time_t end;
        end = time(NULL);
        printf("Τελική τιμή δευτερολέπτων %ld\n", end);
        
        //Ο συνολικός χρόνος είναι η διαφορά τους
        seconds = end-start;
        printf("%ds\n", seconds);
        avg = (float)seconds/times;
        printf("%.3fms\n", avg*1000);
        
        return 0;
}
