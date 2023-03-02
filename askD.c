#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int times = 10000; //������� ���������� ����������
int i = 0; // �������� ��� ��� �������� while loop

//��������� ��� ����� ������� ���������
nothing(){
    
    int x=0;
    x=x+1;
    
}

int main(){

        float avg =0; //����� ���� ���������
        int seconds = 0;  //�������� ��������
    
    	 //�� ��� time ��������� ��� ������ ��� ��� ���������� ���
    	 //��� ������� ��� start �� ������ ����.
        time_t start;
        start = time(NULL);
        printf("������ ���� ������������� %ld\n", start);
        
        //While loop ��� �������� ����������
        while( i < times){
            i++;
            if(fork() == 0){
                nothing();
                exit(0);
            }
        }
        
        //� ������� ��������� ��� �� ����������� �� ���������� �� ��������
        while(i<times){
            i++;
            waitpid(-1,NULL,0);
        }
        
         //�� ��� time ��������� ��� ������ ��� ��� ���������� ���
    	 //��� ������� ��� end �� ������ ����.
        time_t end;
        end = time(NULL);
        printf("������ ���� ������������� %ld\n", end);
        
        //� ��������� ������ ����� � ������� ����
        seconds = end-start;
        printf("%ds\n", seconds);
        avg = (float)seconds/times;
        printf("%.3fms\n", avg*1000);
        
        return 0;
}
