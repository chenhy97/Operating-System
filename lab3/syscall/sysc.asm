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

Pg_Segment dw 0x0000
Pg_Offset dw 0xC000
info_Segment dw 0x0000
info_Offset dw 0xB100
%macro newret 0;inorder to get back,have to match with enter-leave
    pop dx
    jmp dx
%endmacro
%macro SetInt 2;载入中断向量表的宏
    push es
    push di
    push bx
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
    pop bx
    pop di
    pop es
%endmacro
_clearscreen:
    ;enter 0,0
    ;push es
    ;push di
    ;mov ax,0B800h
    ;mov es,ax
    ;mov cx,80*25
    ;mov di,0
    ;mov dx,0
    ;ScreenClean:
    ;    mov [es:di],dx
     ;   add di,2
      ;  loop ScreenClean
   ; pop di
    ;pop es
    ;sleave
    ;newret
    mov ax,0003;have to clean screen by this way,or I can not print the string with cursor
    int 10h
    ret
_printchar:
	enter 0,0
	push di
	mov ax,0xB800
	mov es,ax
	mov ecx,[bp+6];char//ip = 2 bytes,esp = 4 bytes
	mov edi,[bp+10];pos
    mov edx,[bp+14];color
	mov ch,dl
	mov [es:di],cx
	pop di
	leave
    newret
_readinput:;not yet try;wait for input
    enter 4,0;use for output
    mov ah,00h
    int 16h
    mov ah,0
    mov [esp],eax
    mov eax,[esp];save the output by this way
    leave
    newret
_getch:
    enter 0,0
    mov ah,00h
    int 16h
    leave
    newret
_showchar:
    enter 0,0
    push bx
    mov ax,[bp+6] ; ASCII码
    mov ah,0eh ; 功能号
    ;mov bh,0
    mov bl,0 ; Bl设为0
    int 10H ; 调用中断
    pop bx
    leave
    newret
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
_loadP:
    enter 0,0
    push es
    push ds
    push cs
    push ebx
    push dx
    SetInt 20h,_SetINT20h
    mov ax,word [Pg_Segment]
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
    mov bx,word [bp+14]
    mov ah,2
    int 13h
    jmp bx;跳到用户程序。
    back4:
    ;pop ebp
    mov ah,00h
    int 16h
    pop dx
    pop ebx
    pop cs
    pop ds
    pop es
    leave
    newret
_write:
    enter 0,0
    push es
    push ds
    push cs
    push ebx
    push dx
    mov ax,word [info_Segment]
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
    mov bx,word [bp+14]
    mov ah,3
    int 13h
_SetINT20h:
     ;Print Help,HelpLength,1301h,0301h
    ; call print2
    mov ah,01h;检测键盘状态。
    int 16h
    jnz back4
    iret
