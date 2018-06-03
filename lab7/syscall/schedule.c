#include "schedule.h"
void initial_PCB(int index){
    PCB_list[index ].cs = 0x2000+0x1000*(index - 1);//0代表内核，1代表用户程序
    PCB_list[index ].ds = 0x2000+0x1000*(index - 1);//0代表内核，1代表用户程序
    PCB_list[index ].ip = 0x100;
    PCB_list[index ].prg_status = RUN;
    PCB_list[index ].eflags = 512;
    PCB_list[index ].id = index;
    PCB_list[index ].fid = 5;
}

void sys_schedule(){
    int i,j;
    i = _CurrentProg -PCB_list;
    for(j = 0;j < PCB_NUMMER;j ++){
        if(i == 4){
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
        //if(_CurrentProg -> prg_status == READY && index == -1){
         //   index = _CurrentProg - PCB_list;
        //}
    }
    _CurrentProg = PCB_list ;
    return;
}
void sys_exit(){
    _CurrentProg -> prg_status = EXIT;
}
void sys_bolocked(){
    _CurrentProg -> prg_status = BLOCKED;
}
void sys_run(){
    _CurrentProg -> prg_status = RUN;
}
void thread_join(){
    while(counter()){
    }
}
int counter(){
    int i = 0;
    int count = 0;
    for(i = 0;i < PCB_NUMMER - 1;i ++){
        if(PCB_list[i].prg_status == 1){
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