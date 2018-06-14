#include"../syscall/use.h"
#include"../shell/command.h"
#include"kernel.h"
#include "../syscall/stdio.h"
#include "../syscall/schedule.h"
#include "../syscall/time.h"

int main(){
    clearscreen();
   // char str[100] = {};
    //getline(str,10);
   // prints(str);
    Initial_Int();
    init_queue(&readyqueue);
    init_queue(&blockqueue);
   // printTime();
    //Initial_Int_09h();
   // Set_PCB();
    loadProg(25,95,0x2000);
    loadProg(25,125,0x3000);
    loadProg(25,155,0x4000);
    loadProg(25,185,0x5000);
    _loadP(25,215,0x6000);
    _loadP(25,235,0x7000);
    _loadP(25,265,0x8000);
    _loadP(25,295,0x9000);
    //initial_PCB(7);
   //_CurrentProg = PCB_list + 7;
   _CurrentProg = PCB_list;//important! mov dword ptr ds:0x9e60, 0x00009d20,把PCB_list的地址9d20存到ds的9e60处，此后就直接用9e60来织带PCB_list
    Initial_Int_08h();
    //initial_PCB(6);
    //_RunProgress(0x8000);


    char const *Messeage = "Built by Chen Hongyang on March 20, 2018";
    print("===================================================",9,12);

    print("chenhyOS",10,32);
   print(Messeage,11,16); //print the msg
   print("===================================================",12,12);
   

   char a = getch();
   clearscreen(); 
    char const *Msg1 = "Press any key to get help\n\r";
   prints(Msg1);
   print("!",13,39);
   //Initial_Int();
    /*buildmap();还有待解决debug
    void *addr = (void*) 0xB100;
    _loadP(2,21,addr);
    showtable();*/
    terminal();
    return 0;
}