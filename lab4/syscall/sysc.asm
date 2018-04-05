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
global _RunProgress
Pg_Segment dw 0x0000
Pg_Offset dw 0xC000
info_Segment dw 0x0000
info_Offset dw 0xB100
delay equ 4
count db delay
%macro newret 0;inorder to get back,have to match with enter-leave
    pop edx
    jmp dx
%endmacro
%macro SetInt 2;载入中断向量表的宏
    pusha
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
    popa
%endmacro
;===============================
    ; 清屏
;===============================
_clearscreen:
    enter 0,0
    pusha
    mov ax,0003;have to clean screen by this way,or I can not print the string with cursor
    int 10h
    popa
    leave
    newret
;==============================
;   _printchar(char,pos,color)
;==============================
_printchar:
	enter 0,0
	pusha 
	mov ax,0xB800
	mov gs,ax
	mov ecx,[bp+6];char//ip = 2 bytes,esp = 4 bytes
	mov edi,[bp+10];pos
    mov edx,[bp+14];color
	mov ch,dl
	mov [gs:di],cx
	popa
	leave
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
    pusha
    mov ax,[bp+6] ; ASCII码
    mov ah,0eh ; 功能号
    ;mov bh,0
    mov bl,0 ; Bl设为0
    int 10H ; 调用中断
    ;pop ax
    ;pop bx
    popa
    leave
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
    pusha
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov bx,[bp+6]
    call bx
    popa
 S:
    mov ah,00H
    int 16h
    ;popa
    leave
    newret
;============================================================
;   写程序进磁盘[_write(number_shanqu,start_shanqu,address_memory)]**********未封装
;============================================================
;_write:
 ;   enter 0,0
 ;   push es
 ;   push ds
 ;   push cs
   ; push ebx
  ;  push dx
  ;  mov ax,word [info_Segment]
  ;  mov es,ax
  ;  mov dl,0
   ; mov ax,[bp+10];起始扇区号
   ; mov bl,18
   ; div bl
   ; ;inc ah
   ; mov cl,ah
   ; xor ah,ah
   ; mov bl,2
   ; div bl
   ; mov dh,ah
   ; mov ch,al
   ; mov al,byte [bp+6];读多少个扇区
   ; mov bx,word [bp+14]
   ; mov ah,3
   ; int 13h
   ; leave
   ; newret
;========================================================
;                   中断向量程序区
;========================================================
_SetINT20h:
     ;Print Help,HelpLength,1301h,0301h
    ; call print2
    ;pusha
    mov ah,01h;检测键盘状态。
    int 16h
    ;popa
    jnz S
    iret
    
_SetINT08h:
    pusha
    dec byte [count]
    jnz end
    inc byte [gs:((80 * 13 + 39 ) * 2)]
    mov byte [count],delay
end:
    ;push ax
    mov al,20h
    out 20h,al
    out 0A0H,al
    ;pop ax
    popa
    iret
;========================================================
;                   初始化中断向量程序区
;========================================================
_initialInt:
    enter 0,0
    ;push 0;
     SetInt 20h,_SetINT20h
     SetInt 08h,_SetINT08h
     leave
    newret;不能加，否则找不到