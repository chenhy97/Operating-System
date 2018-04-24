#ifndef STDIO_H
#define STDIO_H
extern void _printchar(char pchar, int pos,int color);
extern char _readinput();
extern void _showchar(char phar);
//extern void _RunProgress(void* addr);
void print(char const* Messeage,int row,int colume);
void prints(char const *Messeage);
void print_next_line(char const* Messeage);
void printc(char alpha);
int strlen(char const *Messeage);
void read_and_print_input();
char getch();
void  getline(char str[],int length);
void print_different_color(char const* Messeage,int row,int colume,int color);
int strcmp(char *m1,char const *m2);
#endif