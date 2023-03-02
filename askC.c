#include <stdio.h>
#include <stdlib.h>



int main(){
    int pid;
    for (int i=0; i<5; i++) 
    {
        pid = fork();
        if (pid == -1){//�� ����� �������� � fork() failed
            printf("Error!\n");
            return 0;
        }
        else if (pid == 0) {//��� ��� ����������
            printf("My parent's id is %d. My id is %d. My child's id is %d\n", getppid(), getpid(), getpid()+1);
        	//�� id ��� ������� ��� ����� �� ������ �������.
		}
        else { //�� � fork() > 0 ������������ ���� ������.
        wait();//������� ��� ��� ����������
        exit(0);//����� ���������
        }
    }
}
