#include "schedule.h"
#define EXIT 0
#define RUN 1
#define BLOCKED 2
void initial_PCB(int index){
    PCB_list[index - 1].cs = 0x2000+0x1000*(index - 1);//0代表内核，1代表用户程序
    PCB_list[index - 1].ds = 0x2000+0x1000*(index - 1);//0代表内核，1代表用户程序
    PCB_list[index - 1].ip = 0x100;
    PCB_list[index - 1].prg_status = RUN;
    PCB_list[index - 1].eflags = 512;
    PCB_list[index - 1].prg_name = '1'+index - 1;
}

void sys_schedule(){
    int i,j;
    if(PCB_list  == _CurrentProg ){
        i = 0;
    }
    else if(PCB_list + 1 == _CurrentProg){
        i = 1;
    }
    else if(PCB_list + 2 == _CurrentProg){
        i = 2;
    }
    else if(PCB_list + 3 == _CurrentProg){
        i = 3;
    }
    else if(PCB_list + 4 == _CurrentProg){
        i = 3;
    }
    else{
        i = 3;
    }
    for(j = 0;j < 4;j ++){
        if(i == 3){
            _CurrentProg = PCB_list;
            i = 0;
        }
        else{
            _CurrentProg ++;
            i ++;
        }
        if(_CurrentProg -> prg_status == RUN){
            return;
        }
    }
    _CurrentProg = PCB_list + 5;
    return;
}
void sys_exit(){
    _CurrentProg -> prg_status = EXIT;
}
struct PCB* sys_bolocked(){
    _CurrentProg -> prg_status = BLOCKED;
    sys_schedule();
}
void sys_run(){

}