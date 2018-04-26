[BITS 16]
global  _clearscreen
global _printchar
global _readinput
global _showchar
global _loadP
global _setPoint
global _row_the_screen
global _load_userProgram
global _SetINT20h
global _write
global _initialInt
global _initialInt_09h
global _RunProgress
global _test
global _initialTimer
extern printcircle
extern sys_showline
extern sys_printname
extern sys_printpoem
extern sys_printheart
Pg_Segment dw 0x0000
Pg_Offset dw 0xC000
info_Segment dw 0x0000
info_Offset dw 0xB100
delay equ 8
count db delay
x dw 0
y dw 0
xdul dw 1
ydul dw 1
alpha db '-'
int_09_saved dd 0
program_saved dd 12
color db 1
%macro newret 0;inorder to get back,have to match with enter-leave
    pop edx
    jmp dx
%endmacro
%macro SetInt 2;载入中断向量表的宏
    pusha
    push es
    push ds
    mov ax,cs
    mov ds,ax
    mov ax,0
    mov es,ax
    mov ax,%1
    mov bx,4
    mul bx
    mov di,ax
    mov ax,%2
    mov [es:di],ax
    mov ax,cs
    mov [es:di+2],ax
    pop ds
    pop es
    popa
%endmacro
;===============================
    ; 清屏
;===============================
_clearscreen:
    
    mov ax,0003;have to clean screen by this way,or I can not print the string with cursor
    int 10h
    newret
;==============================
;   _printchar(char,pos,color)
;==============================
_printchar:
	enter 0,0
	;pusha 
	mov ax,0xB800
	mov gs,ax
    push di
	mov ecx,[bp+6];char//ip = 2 bytes,esp = 4 bytes
	mov edi,[bp+10];pos
    mov edx,[bp+14];color
	mov ch,dl
	mov [gs:di],cx
    pop di
	;popa
	leave
    mov ax,1
    newret
;==============================
;   读取一个字符[char _readinput()]**********未封装
;==============================
_readinput:;not yet try;wait for input
    enter 4,0;use for output
    mov ah,00h
    int 16h
    mov ah,0
    mov [esp],eax
    mov eax,[esp];save the output by this way
    leave
    newret
;==============================
;   显示一个字符【_showchar(char)】**********未封装
;==============================
_showchar:
    enter 0,0
    
    mov ax,[bp+6] ; ASCII码
    mov ah,0eh ; 功能号
    ;mov bh,0
    mov bl,0 ; Bl设为0
    int 10H ; 调用中断

    leave
   ; mov ax,1
    newret
;==============================
    ;设置光标位置[_setpoint(row,colume)]，###########还未调试**********未封装
;==============================
_setPoint:;bug????
    enter 0,0
    push bx
    mov bh,0
    mov dh,[bx+6];row
    mov dl,[bx+10];colume
    mov ah,2
    int 10h
    pop bx
    leave
    newret
;_row_the_screen:
;============================================================
;   加载程序进内存[_load(number_shanqu,start_shanqu,address_memory)]**********不同的段内存！*******
;============================================================
_loadP:
    enter 0,0
    pusha
    push es
    push ds
    mov ax,cs
    mov ds,ax
    ;mov ax,0x1000
    mov ax, word [bp+14]
    mov es,ax
    mov dl,0
    mov ax,[bp+10];起始扇区号
    mov bl,18
    div bl
    ;inc ah
    mov cl,ah
    xor ah,ah
    mov bl,2
    div bl
    mov dh,ah
    mov ch,al
    mov al,byte [bp+6];读多少个扇区
    mov bx,0x100
    mov ah,2
    int 13h
    pop ds
    pop es
    popa
    leave
    newret
;===============================================================
;                          运行程序到不同段
;===============================================================
_RunProgress:
    enter 0,0
    ;pusha
    mov ax,cs;加载程序记得段的同步
    mov ds,ax
    mov es,ax
    mov bx,[bp+6]
    mov word [program_saved],0x100;save the program address
    mov word [program_saved+2],bx
    call far [es:program_saved]
 S:
    mov ax,cs;返回内核时，将用户程序的ds，es改回内核程序的ds，es
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov ah,00H
    int 16h
    leave
    newret

;================================================================================================================
;                                                                                                               ;
;                                                                                                               ;
;                                                中断向量程序区                                                    *
;                                                                                                               ;
;                                                                                                               ;
;================================================================================================================
;====================================================
;                   20h:退出用户程序，返回主程序
;====================================================
_SetINT20h:
    push ds
    push es
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
    ;popa
    push bx
    push cx
    push dx
    mov ah,01h;检测键盘状态。
    int 16h
    pop dx
    pop cx
    pop bx
    pop es
    pop ds
    jnz S
    iret
 ;====================================================
;                   08h:时钟中断
;==================================================== 
_SetINT08h:
    pusha
   ; push dx
    push gs
    push ds
    push es
    push ss
    mov ax,cs
    mov es,ax
    mov ds,ax
    mov ss,ax
    dec byte [count]
    jnz end
 notc:
    cmp byte[alpha],'-'
    jnz changleft
    mov byte[alpha],'\'
    jmp show
    changleft:
    cmp byte[alpha],'\'
    jnz changright
    mov byte[alpha],'|'
    jmp show
    changright:
    cmp byte[alpha],'|'
    jnz changheng
    mov byte[alpha],'/'
    jmp show
    changheng:
    cmp byte[alpha],'/'
    jnz notc
    mov byte[alpha],'-'
    jmp show

 show:
    ;push word [alpha]
    ;push word 0
    ;call printcircle;
    ;pop ax;平衡堆栈
    mov cx, 0xB800
    mov gs, cx
    mov ah,0x9
    mov ah, byte [color]
    
    mov al, byte[alpha]
    mov word [gs:142],ax
    mov byte [count],delay

 end:
    mov al,20h
    out 20h,al
    out 0A0H,al
    pop ss
    pop es
    pop ds
    pop gs
    ;pop dx
    popa
    STI
    iret
;====================================================
;                 09h：键盘中断显示ouch
;====================================================
_SetINT09h:
     push ds
     push es
     push ss
     pusha
     mov ax,cs
     mov ds,ax
     mov es,ax
     mov ss,ax
    mov cx, 0xB800
    mov gs, cx
    mov ah, byte [color]
    
    mov al, 'O'
    mov word [gs:120],ax
    mov al, 'U'
    mov word [gs:122],ax
    mov al, 'C'
    mov word [gs:124],ax
    mov al, 'H'
    mov word [gs:126],ax
    mov al, 'S'
    mov word [gs:128],ax
    mov al, '!'
    mov word [gs:130],ax
    mov al, 'O'
    mov word [gs:132],ax
    mov al, 'U'
    mov word [gs:134],ax
    mov al, 'C'
    mov word [gs:136],ax
    mov al, 'H'
    mov word [gs:138],ax
    mov al, '!'
    mov word [gs:140],ax
    popa

    cmp ah,6
    jnz cont
    mov ah,1
    mov byte [color],ah
 cont:
    inc byte [color]
	mov ax, cs
	mov es, ax
	sti
	pushf
	call far [es:int_09_saved];jump to the previous int 9h
    pop ss
    pop es;;;位置在哪里？？？？？思考！！！！！！！！！
    pop ds
	iret
;====================================================
;                  33h：显示斜体“chenhy”
;====================================================
_SetINT33h:
   ; CLI
   ;enter 0,0
    pusha
    push ds
    push gs
    push es
    push ss
    mov ax,cs
    mov es,ax
    mov ds,ax
    mov ss,ax
    push word 0 ;in order to turn back to the program correctly
    call sys_showline
    pop ss
    pop es
    pop gs
    pop ds
    popa
    STI
   ;leave
    iret
;====================================================
;                 34h：显示“I am OS”
;====================================================
_SetINT34h:
     pusha
    push ds
    push gs
    push es
    push ss
    mov ax,cs
    mov es,ax
    mov ds,ax
    mov ss,ax
    push word 0
    call sys_printname
    pop ss
    pop es
    pop gs
    pop ds
    popa
    STI
    iret
;====================================================
;                35h：显示“I am test”
;====================================================
_SetINT35h:
    pusha
    push ds
    push gs
    push es
    push ss
    mov ax,cs
    mov es,ax
    mov ds,ax
    mov ss,ax
    push word 0
    call sys_printpoem
    pop ss
    pop es
    pop gs
    pop ds
    popa
    STI
    iret
;====================================================
;                 36h：显示爱心图案
;====================================================
_SetINT36h:
    pusha
    ;push es
    push ds
    push gs
    push es
    push ss
    mov ax,cs
    mov es,ax
    mov ds,ax
    mov ss,ax
    push word 0
    call sys_printheart
    pop ss
    pop es
    pop gs
    pop ds
    ;pop es
    popa
    STI
    iret
;====================================================
;                 21h系统调用
;====================================================
_SetINT21h:
    enter 0,0
    pusha
    push ds
    push gs
    push es
    mov ax,cs
    mov es,ax
    mov ds,ax
    mov ax,[bp+8];调用int 21h,压入了ebp,和一个ip（？？？），
    cmp ah,0
    jz fn0
    cmp ah,1
    jz fn1
    cmp ah,2
    jz fn2
    cmp ah,3
    jz fn3
    pop es
    pop gs
    pop ds
    popa
    leave
    iret
fn0:;显示一个字符
    mov ax,[bp+10]; ASCII码
    mov ah,0eh ; 功能号
    mov bl,0 ; Bl设为0
    int 10H ; 调用中断
    pop es
    pop gs
    pop ds
    popa
    leave
    iret
fn1:;存入缓冲区
    sub esp,4
    mov ah,00h
    int 16h
    mov ah,0
    mov [esp],eax
    mov eax,[esp];save the output by this way
    add esp,4
    mov fs,ax
    pop es
    pop gs
    pop ds
    popa
    leave
    iret
fn2:;回显
    sub esp,4
    mov ah,00H
    int 16h
    mov ah,0
    mov [esp],eax
    mov eax,[esp]
    mov ah,0eh
    mov bl,0
    int 10h
    add esp,4
    mov fs,ax
    pop es
    pop gs
    pop ds
    popa 
    leave
    iret
fn3:;清屏
    mov ax,0003;have to clean screen by this way,or I can not print the string with cursor
    int 10h
    pop es
    pop gs
    pop ds
    popa
    leave
    iret
fn4:

;========================================================
;                   初始化中断向量程序区
;========================================================
_initialInt:
    enter 0,0
    ;push 0;
     SetInt 20h,_SetINT20h
     SetInt 08h,_SetINT08h
     SetInt 33h,_SetINT33h
     SetInt 34h,_SetINT34h
     SetInt 35h,_SetINT35h
     SetInt 36h,_SetINT36h
     SetInt 21h,_SetINT21h
     leave
    newret;

_initialInt_09h:
     enter 0,0
    mov ax, [09h * 4];hook the int 09h
	mov word [int_09_saved], ax;save the ip
	mov ax, [09h * 4 + 2]
	mov word [int_09_saved + 2], ax
    SetInt 09h,_SetINT09h
    leave
    newret