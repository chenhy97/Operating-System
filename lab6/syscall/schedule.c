#include "schedule.h"
struct PCB PCB_list[5];
void initial_PCB(int index){
    PCB_list[index].cs = 0x1000+0x1000*(index + 1);//5代表内核，0代表用户程序
    PCB_list[index].eip = 0x100;
    PCB_list[index].prg_status = 1;
    PCB_list[index].eflags = 512;
    PCB_list[index].prg_name = '1'+index - 1;
}
void sys_schedule(){
    int i,j;
    if(PCB_list == _CurrentProg){
        i = 0;
    }
    if(PCB_list + 1 == _CurrentProg ){
        i = 1;
    }
    if(PCB_list + 2 == _CurrentProg){
        i = 2;
    }
    if(PCB_list + 3 == _CurrentProg){
        i = 3;
    }
    for(j = 0;j < 4;j ++){
        if(i == 3){
            _CurrentProg = 0;
            i = 0;
        }
        else{
            _CurrentProg ++;
            i ++;
        }
        if(_CurrentProg -> prg_status != 0){
            return;
        }
    }
    _CurrentProg = PCB_list + 4;
    return;
}