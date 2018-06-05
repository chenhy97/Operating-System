#include "../syscall/fork.h"
#include "../syscall/stdio.h"
#include "../syscall/schedule.h"
int main(){
    __asm__("mov $0x7000, %eax\n");
    __asm__("mov %ax, %ds\n");
    __asm__("mov %ax, %es\n");
    __asm__("mov %ax, %ss\n");
    __asm__("mov $0x100, %esp");
    int pid = fork();
    printsint(pid);
    if(pid == -1){
        char const *messeage = "Error in fork\n\r";
        prints(messeage);
    }
    if(pid){
        char const*dad_talk = "I am daddy\n\r";
        prints(dad_talk);
        wait();
       // exit();
    }
    else{
        char const*son_talk = "I am son\n\r";
        prints(son_talk);
        //exit();
    }
}
