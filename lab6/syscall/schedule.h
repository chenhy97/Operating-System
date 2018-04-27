#ifndef SCHEDULE_H
#define SCHEDULE_H
struct PCB{
    unsigned int eax;
    unsigned int ebx;
    unsigned int ecx;
    unsigned int edx;
    unsigned int esi;
    unsigned int edi;
    unsigned int ebp;
    int es;
    int ds;
    int ss;
    unsigned int esp;
    int ip;
    int cs;
    int eflags;
    int prg_status;
    char prg_name;
};
void initial_PCB(int index);
void sys_schedule();

struct PCB* _CurrentProg;
struct PCB PCB_list[6];
#endif