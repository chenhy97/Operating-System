#include "time.h"
#include "stdio.h"

int Get_Hours(){
    int hours = _Get_Hours_1();
    hours = hours * 10 + _Get_Hours_2();
    return hours;
   // printsint(hours);
}
int Get_Minutes(){
    int minutes = _Get_Minutes_1();
    minutes = minutes * 10 + _Get_Minutes_2();
    return minutes;
}
void printTime(){
    int hour = Get_Hours();
    int minute = Get_Minutes();
    printsint(hour);
    prints("h : ");
    printsint(minute);
    printc('m');

}