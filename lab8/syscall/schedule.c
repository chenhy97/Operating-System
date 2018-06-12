#include "schedule.h"

void savePCB(){
    _save();
}
void initial_PCB(int index){
    PCB_list[index ].cs = 0x2000+0x1000*(index - 1);//0代表内核，1代表用户程序
    PCB_list[index ].ds = 0x2000+0x1000*(index - 1);//0代表内核，1代表用户程序
    PCB_list[index ].ss = 0x2000+0x1000*(index - 1);
    PCB_list[index ].esp = 0x100;
    PCB_list[index ].ip = 0x100;
    PCB_list[index ].prg_status = RUN;
    PCB_list[index ].eflags = 512;
    PCB_list[index ].id = index;
    PCB_list[index ].fid = 0;
}
void Set_PCB(){
    int i = 0;
    for(i = 0;i < PCB_NUMMER;i ++){
        PCB_list[i].prg_status = EXIT;
    }
}
int sch_index;
void sys_schedule(){
    int i,j;
    int index = -1;
    i = _CurrentProg - PCB_list;
    for(j = 0;j < PCB_NUMMER;j ++){
        if(i == PCB_NUMMER - 1){
            _CurrentProg = PCB_list + 1;
            i = 1;
        }
        else{
            _CurrentProg ++;
            i ++;
        }
        if(_CurrentProg -> prg_status == RUN){
            return;
        }
    }
    if(isempty(&readyqueue) != 1){
        dequeue(&readyqueue,&sch_index);
        _CurrentProg = PCB_list + sch_index;
        _CurrentProg -> prg_status = RUN;
        return;
    }
    _CurrentProg = PCB_list ;
    return;
}
void sys_exit(){
    __asm__("cli\n");
    _CurrentProg -> prg_status = EXIT;
    __asm__("sti\n");
}



int queuesize,tmp;//一定要是全局，否则dequeue无法将tmp修改
void sys_bolocked(int index){
    __asm__("cli\n");
    PCB_list[index].prg_status = BLOCKED;
    enqueue(&blockqueue,index);
    queuesize = size(&readyqueue);
    int i = 0;
    for(i = 0;i < queuesize;i ++){
        dequeue(&readyqueue,&tmp);
        if(index != tmp){
            enqueue(&readyqueue,tmp);
        }
    }
    __asm__("sti\n");
}
void sys_wakeup(int index){
    __asm__("cli\n");
    //int queuesize,tmp;
    queuesize = size(&blockqueue);
    int i = 0;
    for(i = 0;i < queuesize;i ++){
        dequeue(&blockqueue,&tmp);
        if(index != tmp){
            enqueue(&blockqueue,tmp);
        }
    }
    PCB_list[index].prg_status = READY;
    enqueue(&readyqueue,index);
    __asm__("sti\n");
}
void sys_run(){
    _CurrentProg -> prg_status = RUN;
}

int do_fork(){
   struct PCB* fork_prg;
    fork_prg = PCB_list + 1;
    while(fork_prg < PCB_list+PCB_NUMMER && fork_prg -> prg_status == RUN )    fork_prg = fork_prg + 1;//应该增加used位，防止被覆盖
    if(fork_prg > PCB_list+(PCB_NUMMER - 1)) _CurrentProg -> eax = -1;
    else{
        _Schedule_once();
        __asm__("sub $6,%esp");
        pcb_copy(_CurrentProg,fork_prg);//copy PCB
        __asm__("add $6,%esp");
        fork_prg -> id = (fork_prg - PCB_list);//id = 44,是否有问题？？？
        fork_prg -> fid = _CurrentProg - PCB_list;
        fork_prg -> ds = _CurrentProg -> ds;
        fork_prg -> ss = 0x2000 + 0x1000 * (fork_prg - PCB_list);
        fork_prg -> cs = _CurrentProg -> cs;
        fork_prg -> prg_status = READY;
        
        int index = fork_prg - PCB_list;
        __asm__("sub $6,%esp");
        enqueue(&readyqueue,index); 
        __asm__("add $6,%esp");
        _Schedule_once();
        __asm__("sub $6,%esp");
        _sys_stack_copy(_CurrentProg -> ss,_CurrentProg -> esp,fork_prg -> ss);
        __asm__("add $6,%esp");
        fork_prg -> ip = _CurrentProg -> ip;
        fork_prg -> eax = 0;
        if(fork_prg == _CurrentProg){
            return 0;
        }
        _CurrentProg -> eax = _CurrentProg -> id;
        return _CurrentProg -> eax;
    }
}
void sys_exit_fork(char ch){
    int index = _CurrentProg -> fid;
    sys_wakeup(index);
    PCB_list[_CurrentProg -> fid].eax = ch;
    _CurrentProg -> prg_status = EXIT;
    _Schedule();
}
int sys_wait(){
    int index = _CurrentProg - PCB_list;
    sys_bolocked(index);
    _Schedule();
    return _CurrentProg -> eax;
}
void thread_join(){
    while(counter()){
    }
}
int counter(){
    int i = 0;
    int count = 0;
    for(i = 1;i < PCB_NUMMER;i ++){
        if(PCB_list[i].prg_status != EXIT){
            count ++;
        }
    }
    return count;
}
void pcb_copy(struct PCB* old,struct PCB* newone){
    newone -> eax = old -> eax;
    newone -> ebx = old -> ebx;
    newone -> ecx = old -> ecx;
    newone -> edx = old -> edx;
    newone -> ebp = old -> ebp;
    newone -> esp = old -> esp;
    newone -> esi = old -> esi;
    newone -> edi = old -> edi;
    newone -> es = old -> es;
    newone -> ds = old -> ds;
    newone -> cs = old -> cs;
    newone -> ip = old -> ip;
    newone -> eflags = old -> eflags;
}
void stack_copy(struct PCB* old,struct PCB* newone){
    _sys_stack_copy(old -> ss,old -> esp,newone -> ss);
}
int isempty(struct Queue *queue){
    return (queue -> size == 0);
}
int size(struct Queue *queue){
    return queue -> size ;
}
void enqueue(struct Queue *queue,int data){
    if(queue -> size >= MAX){
        return;
    }
    queue -> size ++;
    queue -> tail = (queue -> tail + 1) % MAX;
    queue -> array[queue -> tail] = data;
}
void dequeue(struct Queue *queue,int * data){
    if(queue -> size <= 0){
        return;
    }
    queue -> size --;
    *data = queue -> array[queue -> head];
    queue -> head = (queue -> head + 1) % MAX;
}
void init_queue(struct Queue *queue){
    queue -> size = 0;
    queue -> tail = -1;
    queue -> head = 0;
}