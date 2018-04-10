#include "../syscall/use.h"
#include "command.h"
void run(int queue[],int size);
int terminal(){
    char const *CMDHead = "hongyangchendeMacBook-Air:chenhyOS users$ ";
    char const *controlMsg1 = "The queue is full,waiting for the Enter Key.";
    char const *controlMsg2 = "The queue is empty!";
    char const *ByeByeMsg = "ByeBye";
    char const *filelist = "Program1 upleft   Program2 upright  \r\nProgram3 downleft  Program4 downright\r\n";
    char const *HelpMsg1 = "Enter 1,2,3,4 to run the program\n\rEnter -q,to quit\n\rEnter -h to print this script again";
    char *help = "-h";
    char *quit = "-q";
    char *lst = "ls";
    int Maxsize = 10;
   
    print_next_line(HelpMsg1);
    
    prints(CMDHead);
    
    char recived[10] = {};
    int index_of_str = 0;
    int i = 1;
    int queue[Maxsize];
    int num_of_queue = 0;
    int number = 0;
    while(i){
        char save = _readinput();
        if(save == 32){//空格
            if(num_of_queue == Maxsize){
                prints("\n\r");
                print_next_line(controlMsg1);
                prints(CMDHead);
                continue;
            }
            _showchar(save);
            queue[num_of_queue] = number;
            num_of_queue ++;
            number = 0;
            continue;
        }
       else  if(save == 13){//回车
            if(num_of_queue != 0 || number != 0 ||strcmp(recived,help) == 1 ||strcmp(recived,quit) == 1 || strcmp(recived,lst) == 1){
                if(strcmp(recived,help) == 1 || strcmp(recived,quit) == 1 || strcmp(recived,lst) == 1){//判断字符串
                    prints("\r\n");
                    if(strcmp(recived,help) == 1){
                         prints(HelpMsg1);
                    }
                    else if(strcmp(recived,quit) == 1){
                        prints(ByeByeMsg);
                        //prints(filelist);
                    }
                    else if(strcmp(recived,lst) == 1){
                        prints(filelist);
                    }
                    while(index_of_str != 0){//clear the string
                        recived[index_of_str] = 0;
                        index_of_str --;
                      }
                    prints("\n\r");
                    prints(CMDHead);
                    continue;
                }
            
                if(number != 0){
                    queue[num_of_queue] = number;
                    num_of_queue++;
                }
                run(queue,num_of_queue);
                num_of_queue = 0;
                number = 0;
                prints(CMDHead);
                while(index_of_str != 0){//clear the string
                  recived[index_of_str] = 0;
                  index_of_str --;
                }
                continue;
            }
            else{
                 prints("\n\r");
                print_next_line(controlMsg2);
                prints(CMDHead);
                while(index_of_str != 0){//clear the string
                  recived[index_of_str] = 0;
                  index_of_str --;
                }
                continue;
            }

            
        }
        else if(save >= '0' && save <='9'){
           _showchar(save);
            number = number * 10 + save -'0';
            continue;
        }
        else{
           _showchar(save);
           // if(save == '-' || save == 'q' || save == 'h' || save == 'l' || save =='s'){
            if(index_of_str < 10){
                recived[index_of_str] =  save;
                index_of_str ++;
                recived[index_of_str] = 0;
                //_showchar('0' + strlen(recived));
                //continue;
            }
            else{
                continue;
            }
            //}
            
        }
        //else if(save )
    }
}
void run(int queue[],int size){
    int i = 0;
    _clearscreen();
    for(i = 0;i < size;i ++){
        //_delay();
        //_load_userProgram(queue[i]);
        //_delay();
        if(queue[i] == 1){
            _loadP(2,23,0xC000);
        }
        if(queue[i] == 2){
            _loadP(2,25,0xC000);
        }
        if(queue[i] == 3){
            _loadP(2,27,0xC000);
        }
        if(queue[i] == 4){
            _loadP(2,29,0xC000);
        }
    }
     _clearscreen();
}