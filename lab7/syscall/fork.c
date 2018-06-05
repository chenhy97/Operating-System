#include "fork.h"
#include "use.h"
#include "schedule.h"
int fork(){
    int a = _fork_user();
    return a;
}
void wait(){
    _wait();
}