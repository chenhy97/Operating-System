[BITS 16]
[global test]
test:
    
   mov	ax, cs	; 置其他段寄存器值与CS相同		
    mov	ds, ax	; 数据段
    mov ss,ax
    mov sp,0x100
    ;push 	ax     	;系统调用功能号0压栈，传递给系统服务处理程序
    ;int 21h        ;产生中断，用户程序ouch.asm中，调用0号功能。
    int 33h
    int 39h
    ;int 34h
    ;int 35h
    ;int 36h
    ;int 35h
    ;push ax
    ;int 33h
    int 38h
    ;push 0
    ;call RTC_Timer
    jmp $
    ;popa
    ;int 20h
    ;jmp test
section .data
    myname db "chy"