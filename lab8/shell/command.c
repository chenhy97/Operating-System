#include "../syscall/use.h"
#include "command.h"
#include "../syscall/stdio.h"
#include "../syscall/time.h"
void run(int queue[],int size);
int terminal(){
    char const *help = "help";
    char const *quit = "quit";
    char const *lst = "ls";
    char const *CMDHead = "hongyangchendeMacBook-Air:chenhyOS users$ ";
    char const *controlMsg1 = "The queue is full,waiting for the Enter Key.";
    char const *controlMsg2 = "The queue is empty!";
    char const *ByeByeMsg = "ByeBye";
    char const *filelist = "Program1 upleft   Program2 upright  \r\nProgram3 downleft  Program4 downright";
    char const *HelpMsg1 = "Enter 1,2,3,4 to run the program\n\rEnter quit,to quit\n\rEnter help to print this script again";
    int Maxsize = 10;
    print_next_line(HelpMsg1);
    
            // _RunProgress(0xC000);
   prints(CMDHead);
    char recived[10] = {};
    recived[0] = 0;
    int index_of_str = 0;
    int i = 1;
    int queue[Maxsize];
    int num_of_queue = 0;
    int number = 0;
    int k = 0;
    /*for(k = 0;k < Maxsize;i ++){
        queue[k] = 0;
    }*/
    while(i){
        char save = getch();
        if(save == 32){//空格
            if(num_of_queue == Maxsize){
                prints("\n\r");
                print_next_line(controlMsg1);
                prints(CMDHead);
                continue;
            }
            printc(save);
            queue[num_of_queue] = number;
            num_of_queue ++;
            number = 0;
            continue;
        }
       else  if(save == 13){//回车
            int strcmp1 = strcmp(recived,quit);
            int strcmp2 = strcmp(recived,help);
            int strcmp3 = strcmp(recived,lst);
            //printsint(strcmp2);
            if(num_of_queue != 0 || number != 0 ||strcmp1 == 1 ||strcmp2 == 1 || strcmp3 == 1){
                if(strcmp1 == 1 || strcmp2 == 1 || strcmp3 == 1){//判断字符串  
                    print_next_line("");
                    if(strcmp1 == 1){
                        print_next_line(ByeByeMsg);
                        index_of_str = 0;
                        recived[index_of_str] = 0;
                    }                  
                   else if(strcmp2 == 1){
                         print_next_line(HelpMsg1);
                        index_of_str = 0;
                        recived[index_of_str] = 0;
                    }
                    else if(strcmp3 == 1){
                        print_next_line(filelist);
                        index_of_str = 0;
                      recived[index_of_str] = 0;
                    }
                        //prints(recived);
                    prints(CMDHead);
                    continue;
                }
            
                else if(number != 0||num_of_queue != 0){
                    if(number != 0 ){
                         printsint(number);
                        queue[num_of_queue] = number;
                        num_of_queue++;
                    }
                    run(queue,num_of_queue);
                    num_of_queue = 0;
                    number = 0;
                    clearscreen();
                    prints(CMDHead);
                    index_of_str = 0;
                    recived[index_of_str] = 0;
                    continue;
                }
            }
            else{
                 prints("\n\r");
                print_next_line(controlMsg2);
                prints(CMDHead);
                index_of_str = 0;
                recived[index_of_str] = 0;
                continue;
            }
        }
        else if(save >= '0' && save <='9'){
           printc(save);
            number = number * 10 + save -'0';
           // printsint(number);
            continue;
        }
        else{
           printc(save);
           // if(save == '-' || save == 'q' || save == 'h' || save == 'l' || save =='s'){
            if(index_of_str < 10){
                recived[index_of_str] =  save;
                index_of_str ++;
                recived[index_of_str] = 0;
            }
            else if(index_of_str >= 10){
                prints("not added");
            }
        }
    }
}
void run(int queue[],int size){
    int j = 0;
    clearscreen();
    for(j = 0;j < size;j ++){
        //_delay();
        //_load_userProgram(queue[j]);
        //_delay();
        initial_PCB(queue[j]);
    }
    //for(j = 0;j < size;j ++){
     //   _RunProgress(queue[j]);
    //}
    
   // clearscreen();;
   //thread_join();
    //Initial_Int_08h();
}