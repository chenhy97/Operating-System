//#include "testsem.h"
#include "../syscall/fork.h"
#include "../syscall/stdio.h"
int bankbalance;
int pid,sem_id;
int t;
int i,j;
int totalsave ;
int totaldraw ;
int main(){
    __asm__("mov $0x8000, %eax\n");
    __asm__("mov %ax, %ds\n");
    __asm__("mov %ax, %es\n");
    __asm__("mov %ax, %ss\n");
    __asm__("mov $0x100, %esp");
    bankbalance = 1000;
    totaldraw = 0;
    totalsave = 0;
    sem_id = GetSem(1);
    //__asm__("sub $22,%esp");
    pid = fork();
    //__asm__("add $22,%esp");
    if(pid == -1){
        prints("error in fork!");
        return 0;
    }
    if(pid){
        i = 0;
        for(i = 0;i < 50;i ++){
            P(sem_id);
            t = bankbalance;
            //delay(2);
            t = t + 10;
           // delay(3);
            bankbalance = t;
            totalsave = totalsave + 10;
            prints("papa:bankbalance = ");
            printsint(bankbalance);
            prints(" papa:totalsave = ");
            printsint(totalsave);
            prints("\n\r");
            V(sem_id);
        }
    }
    else{
        for(j = 0;j < 35;j ++){
            P(sem_id);
            t = bankbalance;
            //delay(2);
            t = t - 20;
            //delay(3);
            bankbalance = t;
            totaldraw = totaldraw + 20;
            prints("son:money = ");
            printsint(bankbalance);
            prints(" son:I used: ");
            printsint(totaldraw);
            prints("\n\r");
            V(sem_id);
        }
    }
    prints("\n\rfinished!");
    exit(0);
}
void delay(int n){
    int ii,jj,a;
    for(ii = 0;ii < 30 * n;ii ++ ){
        for(jj = 0;jj < 3000;jj ++){
            a += 1;
            a -= 1;
        }
    }
}