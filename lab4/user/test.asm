[BITS 16]
[global test]
test:
    
   mov	ax, cs	; 置其他段寄存器值与CS相同		
    mov	ds, ax	; 数据段
    mov ss,ax
    mov	ax,100h  ;设置栈指针
    mov	sp,ax
    ;push 	ax     	;系统调用功能号0压栈，传递给系统服务处理程序
    ;int 21h        ;产生中断，用户程序ouch.asm中，调用0号功能。
    ;int 34h
    int 36h
    ;int 35h
    ;push ax
    ;int 33h
    
    mov ah,2
    push ax
    int 21h
    int 35h
    jmp $
    ;popa
    ;int 20h
    ;jmp test
section .data
    myname db "chy"