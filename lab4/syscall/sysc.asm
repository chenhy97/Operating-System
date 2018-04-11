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
global _getch
global _write
global _initialInt
global _initialInt_09h
global _RunProgress
global _test
extern printcircle
extern showline
extern printname
extern printpoem
extern printheart
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
;   加载程序进内存[_load(number_shanqu,start_shanqu,address_memory)]**********未封装
;============================================================
_loadP:
    enter 0,0
    pusha
    push es
    push ds
    mov ax,cs
    mov ds,ax
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
    mov bx,word [bp+14];内存地址
    mov ah,2
    int 13h
    pop ds
    pop es
    popa
    leave
    newret
_RunProgress:
    enter 0,0
    ;pusha
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov bx,[bp+6]
    call bx
 S:
    mov ah,00H
    int 16h
    leave
    newret
;========================================================
;                   中断向量程序区
;========================================================
_SetINT20h:
    ;mov ax,cs
    ;mov ds,ax
    ;mov es,ax
    ;popa
    push bx
    push cx
    push dx
    mov ah,01h;检测键盘状态。
    int 16h
    pop dx
    pop cx
    pop bx
    jnz S
    iret
    
_SetINT08h:
    pusha
   ; push dx
    push gs
    push ds
    push es
    mov ax,cs
    mov es,ax
    mov ds,ax
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
    mov word [gs:220],ax
    mov byte [count],delay

end:
    mov al,20h
    out 20h,al
    out 0A0H,al
    pop es
    pop ds
    pop gs
    ;pop dx
    popa
    STI
    iret
_SetINT09h:
     push ds
     push es
     pusha
     mov ax,cs
     mov ds,ax
     mov es,ax
    mov cx, 0xB800
    mov gs, cx
    mov ah, byte [color]
    
    mov al, 'O'
    mov word [gs:10],ax
    mov al, 'U'
    mov word [gs:12],ax
    mov al, 'C'
    mov word [gs:14],ax
    mov al, 'H'
    mov word [gs:16],ax
    mov al, 'S'
    mov word [gs:18],ax
    mov al, '!'
    mov word [gs:20],ax
    mov al, 'O'
    mov word [gs:22],ax
    mov al, 'U'
    mov word [gs:24],ax
    mov al, 'C'
    mov word [gs:26],ax
    mov al, 'H'
    mov word [gs:28],ax
    mov al, '!'
    mov word [gs:30],ax
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
	call far [es:int_09_saved]
    pop es;;;位置在哪里？？？？？思考！！！！！！！！！
    pop ds
	iret
_SetINT33h:
   ; CLI
   ;enter 0,0
    pusha
    push ds
    push gs
    push es
    mov ax,cs
    mov es,ax
    mov ds,ax
    push word 0
    call showline
    pop es
    pop gs
    pop ds
    popa
    STI
   ;leave
    iret
_SetINT34h:
     pusha
    push ds
    push gs
    push es
    mov ax,cs
    mov es,ax
    mov ds,ax
    push word 0
    call printname
    pop es
    pop gs
    pop ds
    popa
    STI
    iret
_SetINT35h:
    pusha
    push ds
    push gs
    push es
    mov ax,cs
    mov es,ax
    mov ds,ax
    push word 0
    call printpoem
    pop es
    pop gs
    pop ds
    popa
    STI
    iret
_SetINT36h:
    pusha
    ;push es
    push ds
    push gs
    push es
    mov ax,cs
    mov es,ax
    mov ds,ax
    push word 0
    call printheart
    pop es
    pop gs
    pop ds
    ;pop es
    popa
    STI
    iret
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
    mov ax, [09h * 4]
	mov word [int_09_saved], ax
	mov ax, [09h * 4 + 2]
	mov word [int_09_saved + 2], ax
    SetInt 09h,_SetINT09h
    leave
    newret