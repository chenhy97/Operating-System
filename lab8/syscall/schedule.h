#ifndef SCHEDULE_H
#define SCHEDULE_H
#define EXIT 0
#define RUN 1
#define BLOCKED 2
#define READY 3
#define PCB_NUMMER 20
#define MAX 30
#define SemMax 30

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
struct Queue{
    int tail,head,size;
    int array[MAX];
};
struct Semaphone{
    int count;
    struct Queue semaque;
    int used;
};

struct PCB PCB_list[PCB_NUMMER];
struct PCB* _CurrentProg ;
struct Queue blockqueue;
struct Queue readyqueue;
struct Semaphone SEM_list[SemMax];


void pcb_copy(struct PCB* old,struct PCB* newone);
void stack_copy(struct PCB* old,struct PCB* newone);
void initial_PCB(int index);
void sys_schedule();
void Set_PCB();
void _save();
int do_fork();

int isempty(struct Queue *queue);
int size(struct Queue *queue);
void enqueue(struct Queue *queue,int data);
void dequeue(struct Queue *queue,int * data);
void rmele(struct Queue *queue,int data);
void init_queue(struct Queue *queue);

int do_SemGet(int value);
void do_SemFree(int s);
void do_P(int s);
void do_V(int s);
#endif