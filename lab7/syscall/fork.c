#include "fork.h"
#include "schedule.h"
int fork(){
   struct PCB* fork_prg;
    fork_prg = PCB_list + 1;
    while(fork_prg - PCB_list<= PCB_NUMMER && fork_prg -> prg_status == RUN)    fork_prg = fork_prg + 1;
    if(fork_prg - PCB_list> PCB_NUMMER) _CurrentProg -> eax = -1;
    else{
        pcb_copy(_CurrentProg,fork_prg);//copy PCB
        fork_prg -> id = fork_prg - PCB_list;
        fork_prg -> fid = _CurrentProg - PCB_list;
        fork_prg -> ss = 0x2000 + 0x1000 * (fork_prg - PCB_list);
        fork_prg -> prg_status = READY;
        stack_copy(_CurrentProg,fork_prg);
        fork_prg -> eax = 0;
        _CurrentProg -> eax = fork_prg -> id;
    }
}