[BITS 16]
global _start;必须要有这个入口函数，否则生成不了bin
;org 7c00h
OS_SEGMENT equ 0000h
OS_OFFSET equ 07d00h

_start:
	mov ax,cx
	mov ds,ax
	mov es,ax

ReadOS:
	;OS OFFSET
	mov ax, OS_SEGMENT
	mov es, ax

	mov dl,0
    mov ax,2;起始扇区号
    mov bl,18
    div bl
    ;inc ah
    mov cl,ah
    xor ah,ah
    mov bl,2
    div bl
    mov dh,ah
    mov ch,al
    mov al,18;读多少个扇区
    mov bx,OS_OFFSET
    mov ah,2
    int 13h
	
	mov ah,2                 ; 功能号
    mov al,18                 ;扇区数
    mov dh,0                 ;磁头号 ; 起始编号为0
    mov ch,2                 ;柱面号 ; 起始编号为0
    add bx, 18*512 ;偏移地址; 存放数据的内存偏移地址
    int 13h 

	mov ah,2                 ; 功能号
    mov al,18                 ;扇区数
    mov dh,1                 ;磁头号 ; 起始编号为0
    mov ch,2                 ;柱面号 ; 起始编号为0
    add bx, 18*512 ;偏移地址; 存放数据的内存偏移地址
    int 13h

	 mov ah,2                 ; 功能号
    mov al,18                 ;扇区数
    mov dh,0                 ;磁头号 ; 起始编号为0
    mov ch,3                 ;柱面号 ; 起始编号为0
    add bx, 18*512 ;偏移地址; 存放数据的内存偏移地址
    int 13h

	 mov ah,2                 ; 功能号
    mov al,18                 ;扇区数
    mov dh,1                 ;磁头号 ; 起始编号为0
    mov ch,3                 ;柱面号 ; 起始编号为0
    add bx, 18*512 ;偏移地址; 存放数据的内存偏移地址
    int 13h
JUMP_TO_OS:
	;Clear Screen
	mov ax, 3
	int 10h
	;Print
	mov ax, cs
	mov es, ax
	mov ax, 1301h
	mov bx, 0006h
	mov dh, 10
	mov dl, 35
	mov bp, Load_Info
	mov cx, Load_Info_Len
	int 10h
	;Check Key
	mov ah, 00h
	int 16h
	;Enter Kernel
	jmp 0:OS_OFFSET

Load_Info dw "Press any key..."
Load_Info_Len equ $ - Load_Info
times 510 - ($ - $$) db 0
db 0x55
db 0xaa