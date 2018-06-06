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
        if(_CurrentProg -> prg_status == READY && index == -1){
           index = _CurrentProg - PCB_list;
        }
    }
    if(index != -1){
        _CurrentProg = PCB_list + index;
        return;
    }
    _CurrentProg = PCB_list ;
    return;
}
void sys_exit(){
    _CurrentProg -> prg_status = EXIT;
}
void sys_exit_fork(char ch){
    _CurrentProg -> prg_status = EXIT;
    PCB_list[_CurrentProg -> fid].prg_status = READY;
    PCB_list[_CurrentProg -> fid].eax = ch;
    _Schedule();
}
void sys_bolocked(){
    _CurrentProg -> prg_status = BLOCKED;
}
void sys_run(){
    _CurrentProg -> prg_status = RUN;
}
int sys_wait(){
    _CurrentProg -> prg_status = BLOCKED;
    _Schedule();
    return _CurrentProg -> eax;
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
       // __asm__("enter $0,$0");
        _Schedule_once();
        __asm__("sub $6,%esp");
        _sys_stack_copy(_CurrentProg -> ss,_CurrentProg -> esp,fork_prg -> ss);
        __asm__("add $6,%esp");
        fork_prg -> ip = _CurrentProg -> ip;
        fork_prg -> eax = 0;
        if(fork_prg == _CurrentProg){
            return 0;
        }
        _CurrentProg -> eax = fork_prg -> id;
        return _CurrentProg -> eax;
    }
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
