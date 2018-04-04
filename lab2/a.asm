;程序源代码（myos1.asm）
org  7c00h		; BIOS将把引导扇区加载到0:7C00h处，并开始执行
OffSetOfUserPrg1 equ 0A100h
%macro SetInt 2;载入中断向量表的宏
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
%endmacro

mov	ax, cs	       ; 置其他段寄存器值与CS相同
mov	ds, ax	       ; 数据段
SetInt 20h,SetINT20h

%macro Print 4
	push es
	push ds
	push cs
	push bp
	push bx
	push ax
	push cx
	push dx
	mov bp,%1;bp为当前串偏移地址
	mov ax,cs;es:bp = 串地址
	mov es,ax;es = ds
	mov cx,%2;cx = 串长（=9）
	mov ax,%3;AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov bx,0007h;
	mov dx,%4;行号和列号
	int 10h;BIOS的10h功能：显示一行字符
	pop dx
	pop cx
	pop ax
	pop bx
	pop bp
	pop cs
	pop ds
	pop es
%endmacro

Start:
	call clean
	Print Message,MessageLength,1301h,0
	;Print Help,HelpLength,1301h,0508h
EnterX:
	mov ah,0 ; 功能号
	int 16H ; 调用中断
	mov ah,0eh
	mov bl,0
	int 10h
	sub al,'0'
	add al,1
	mov byte [save],al;	非扇区有的是不会读到的
LoadnEx:
     ;读软盘或硬盘上的若干物理扇区到内存的ES:BX处：
    call clean
    mov ax,cs                ;段地址 ; 存放数据的内存基地址
    mov es,ax                ;设置段地址（不能直接mov es,段地址）
    mov bx, OffSetOfUserPrg1 ;偏移地址; 存放数据的内存偏移地址
    mov ah,2                 ; 功能号
    mov al,1                 ;扇区数
    mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
    mov dh,0                 ;磁头号 ; 起始编号为0
    mov ch,0                 ;柱面号 ; 起始编号为0
    mov cl,byte [save]                 ;起始扇区号 ; 起始编号为1
    int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域中
    jmp OffSetOfUserPrg1
e_of_p:
	Print M1,M1Length,1301h,0
	Print M2,M2Length,1301h,08h
	mov ah,0h
	int 16h
	cmp al,'y'
	jz Start
	mov ah,4ch
	int 21h
AfterRun:
      jmp $ 
                          ;无限循环
 
 print2:;显示字符串
 	push es
 	push si
 	mov ax,0B800H
 	mov es,ax
 	mov si,Help
 	mov di,0
 	mov cx,HelpLength
S:
 	mov al,byte [ds:si]
 	mov byte [es:di],al
 	mov byte [es:di+1],7
 	add di,2
 	inc si
 	dec cx
 	cmp cx,0
 	jnz S
 	pop si
 	pop es
 	ret                    
SetINT20h:
	 ;Print Help,HelpLength,1301h,0301h
	 call print2
	mov ah,01h;检测键盘状态。
	int 16h
	jnz back
	iret
back:
	cmp al,'q'
	jnz h
	call 0:clean
	mov ah,0
	int 16h;清除缓冲区
	jmp 0:e_of_p;调用退出程序
h:	
	cmp al,'b'
	jz back_to_Seclect;选择扇区程序
	jmp 0:EnterX
back_to_Seclect:
	mov ah,0
	int 16h
	jmp 0:EnterX
	iret


clean:
	push es
	mov ax,ScreenSave
	mov es,ax
	mov cx,80*25
	mov si,0
	mov dx,0
	ScreenClean:
		mov [es:si],dx
		add si,2
		loop ScreenClean
	pop es
	ret

	Help: db '1:upLeft,2:upRight,3:downLeft,4:downRight,q to quit;b to pause'
	HelpLength equ ($-Help)
	Message: db 'Hello, MyOs is loading user program...'
	MessageLength  equ ($-Message)
	M1 db 'Bye,Bye'
	M1Length equ ($-M1)
	M2 db 'You can choose to start again:[Y/N]'
	M2Length equ ($-M2)
	save: db 1
	ScreenSave equ 0B800H
    times 510-($-$$) db 0
    db 0x55,0xaa
;8100h前面的100h为PSP，在PSP里面按照规定存下程序的CS，IP。
;然后调用int 21h，4ch。
;即可实现从用户程序到监控程序的跳转。