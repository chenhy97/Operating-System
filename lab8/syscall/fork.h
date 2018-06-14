#ifndef FORK_H
#define FORK_H
//int do_fork();
int fork();
char wait();
int GetSem(int value);
void SemFree(int value);
void P(int s);
void V(int s);
#endif