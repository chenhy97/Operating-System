#include "fork.h"
#include "use.h"
#include "schedule.h"
int fork(){
    int a = _fork_user();
    return a;
}
char wait(){
    int temp_ch = _wait();
    char ch = '0' + temp_ch;
    return ch;
    //_wait();
}
void exit(char ch){
    _exit(ch);
}