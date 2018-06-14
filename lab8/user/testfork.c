#include "../syscall/fork.h"
#include "../syscall/stdio.h"
int pid;
int main(){
    __asm__("mov $0x7000, %eax\n");
    __asm__("mov %ax, %ds\n");
    __asm__("mov %ax, %es\n");
    __asm__("mov %ax, %ss\n");
    __asm__("mov $0x100, %esp");
    char const* str = "I love 10";
    pid = fork();
    printsint(pid);
    if(pid == -1){
        char const *messeage = "Error in fork\n\r";
        prints(messeage);
    }
    else if(pid){
        char const*dad_talk = "I am daddy\n\r";
        prints(dad_talk);
        char ch = wait();
        printc(ch);
        exit(6);
    }
    else{
        char const*son_talk = "I am son\n\r";
        prints(son_talk);
        int num = countLetterNum("Il10abcd");
        exit(num);
    }
}
int pid;
int countLetterNum(char const* s1){
    int index = 0;
    int count = 0;
    while(s1[index] != 0){
        if((s1[index] >= 'a' && s1[index] <= 'z' )||(s1[index] >= 'A' && s1[index] <= 'Z') ){
            count ++;
        }
        index ++;
    }
    return count;
}
