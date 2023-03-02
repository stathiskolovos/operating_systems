#include <stdio.h>
#include <stdlib.h>

int main(){
    
    //�������� ��� id ��� ������
    printf("Parent. Pid = %d\n", getpid());
        
    //For loop ��� ��� �������� ��� ����������.
    for(int i=0; i<4; i++){
        if(fork() == 0){//��� fork()==0 ������������ ���� ����������
            printf("Child's pid %d from Parent pid %d\n", getpid(), getppid());
            exit(0);//����� ��������� ����������.
        }
    }
    
    //For loop ��� �� ��������� � ������� �� ����������� �� ����������
    for(int i=0;i<4; i++){
        wait();
    }
}
