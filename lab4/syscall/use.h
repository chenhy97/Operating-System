//#pragma once
#ifndef USE_H
#define USE_H
extern void _clearscreen();
extern void _printchar(char pchar, int pos,int color);
extern char _readinput();
extern void _showchar(char phar);
extern void _setPoint();
extern void _row_the_screen();
extern void _getch();
extern void  _write(int count,int start,void* addr);
extern void _initialInt();
//extern void _RunProgress(void* addr);
void print(char const* Messeage,int row,int colume);
void prints(char const *Messeage);
void print_next_line(char const* Messeage);
void printc(char alpha);
int strlen(char const *Messeage);
void read_and_print_input();
char waitforinput();
void clearscreen();
int strcmp(char *m1,char const *m2);
void bulidmap();
void showtable();
void Initial_Int();
struct info{
    char name[4][16];
    int size[4];
    int sector[4];
    int num;
};
#endif