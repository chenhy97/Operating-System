#ifndef SCHEDULE_H
#define SCHEDULE_H
#define EXIT 0
#define RUN 1
#define BLOCKED 2
#define READY 3
#define PCB_NUMMER 6

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
    int prg_status ;
    int id;
    int fid;
};

struct PCB* _CurrentProg;
struct PCB PCB_list[6];
void pcb_copy(struct PCB* old,struct PCB* newone);
void stack_copy(struct PCB* old,struct PCB* newone);
void initial_PCB(int index);
void sys_schedule();


#endif