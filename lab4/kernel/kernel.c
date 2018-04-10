#include"../syscall/use.h"
#include"../shell/command.h"
#include"kernel.h"
int main(){
    Initial_Int();
    clearscreen();
    Initial_Int_09h();
    _loadP(5,25,0xC000);
    //_loadP(4,21,0xC000);
    _RunProgress(0xC000);

    char const *Messeage = "Built by Chen Hongyang on March 20, 2018";
    print("===================================================",9,12);

    print("chenhyOS",10,32);
   print(Messeage,11,16); //print the msg
   print("===================================================",12,12);
   

   clearscreen(); 
    char const *Msg1 = "Press any key to get help\n\r";
   prints(Msg1);
   print("!",13,39);
   //Initial_Int();
   char a = waitforinput();  
    
    /*buildmap();还有待解决debug
    void *addr = (void*) 0xB100;
    _loadP(2,21,addr);
    showtable();*/
    terminal();
    return 0;
}