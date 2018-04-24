#include"../syscall/use.h"
#include"../shell/command.h"
#include"kernel.h"
#include "../syscall/stdio.h"
int main(){
    clearscreen();
   // char str[100] = {};
    //getline(str,10);
   // prints(str);
    Initial_Int();
    Initial_Int_08h();
    Initial_Int_09h();
    loadProg(10,25,0x1000);
    loadProg(10,35,0x2000);
    loadProg(10,45,0x3000);
    loadProg(10,55,0x4000);
    //_loadP(10,65,0x1000);
    //_RunProgress(0x1000);


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