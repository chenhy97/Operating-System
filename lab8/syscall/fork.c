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
int GetSem(int value){
    int sema = _GetSem(value);
    return sema;
}
void SemFree(int value){
    _FreeSem(value);
}
void P(int s){   
    _Pr(s);
}
void V(int s){
    _Vr(s);
}