#ifndef __TESTFORK_H_
#define __TESTFORK_H_
__asm__(".globl _start\n");
__asm__("_start:\n");
__asm__("jmpl $0, $main\n");

#endif