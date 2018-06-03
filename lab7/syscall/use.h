//#pragma once
#ifndef USE_H
#define USE_H
extern void _clearscreen();
extern void _setPoint();
extern void  _write(int count,int start,void* addr);
extern void _initialInt();
extern void _initialInt_09h();
extern void _row_the_screen();
extern void _loadP(int count,int begin,int memory_position);





void clearscreen();
void bulidmap();
void showtable();
void Initial_Int();
void Initial_Int_09h();
void Initial_Int_08h();
void loadProg(int count,int begin,int memory_position);
struct info{
    char name[4][16];
    int size[4];
    int sector[4];
    int num;
};
#endif