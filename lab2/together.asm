global start
org 0A100h
section .text
Start:
	mov ax,cs
	mov ds,ax
	mov ax,0B800h
	mov es,ax
	;mov ax,BOOTSEG;涉及到内存寻址时，会将它作为偏移量加上
	;mov ds,ax
	call print
	jmp show




DnRt:
	call kill
	inc word [x]
	inc word [y]
	mov bx, word [x]
	mov ax, 25
	sub ax,bx
   jz dr2ur
   	mov bx,word [y]
   	mov ax,80
   	sub ax,bx
   jz dr2dl
   	jmp show
dr2ur:
	mov byte [color],BLUE
	mov word [x],23
	mov byte [rdul],Up_Rt
	jmp show
dr2dl:
	mov byte [color],sR
	mov word [y],78
	mov byte [rdul],Dn_Lt
	jmp show

UpRt:
	call kill
	dec word [x]
	inc word [y]
	mov bx,word [y]	
	mov ax,80
	sub ax,bx
   jz ur2ul
   	mov bx,word [x]
   	mov ax,-1
   	sub ax,bx
   jz ur2dr
   	jmp show
ur2ul:
	mov byte [color],R
	mov word [y],78
	mov byte [rdul],Up_Lt
	jmp show
ur2dr:
	mov byte [color],Gray
	mov word [x],1
	mov byte [rdul],Dn_Rt
	jmp show

UpLt:
	call kill
	dec word [x]
	dec word [y]
	mov bx,word [x]
	mov ax,-1
	sub ax,bx
   jz ul2dl
   	mov bx,word [y]
   	mov ax,-1
   	sub ax,bx
   jz ul2ur
   	jmp show
ul2dl:
	mov byte [color],G
	mov word [x],1
	mov byte [rdul],Dn_Lt
	jmp show
ul2ur:
	mov byte [color],Q
	mov word [y],1
	mov byte [rdul],Up_Rt
	jmp show

DnLt:
	call kill
	inc word [x]
	dec word [y]
	mov bx,word [y]
	mov ax,-1
	sub ax,bx
   jz dl2dr
   	mov bx,word [x]
   	mov ax,25
   	sub	ax,bx
   jz dl2ul
   	jmp show
dl2dr:
	mov byte [color],W
	mov word [y],1
	mov byte [rdul],Dn_Rt
	jmp show
dl2ul:
	;mov byte [color],Yel
	mov word [x],23
	mov byte [rdul],Up_Lt
	jmp show


kill:
	xor ax,ax
	mov ax,word [x]
	mov bx,80
	mul bx
	add ax,word [y]
	mov bx,2
	mul bx
	mov bx,ax
	mov ah,byte [kcolor]
	mov al,byte [kchar]
	mov [es:bx],ax
	ret





show:
	int 20h
	call print
	xor ax,ax
	mov ax,word [x]
	mov bx,80
	mul bx
	add ax,word [y]
	mov bx,2
	mul bx
	mov bx,ax
	mov ah,byte [color]
	mov al,byte [char]
	mov [es:bx],ax
	jmp loop1

loop1:
	mov cx, word [count]
	LOOP1:
		mov ax, word [dcount]	
		LOOP2:
			dec ax
			jg LOOP2
	loop LOOP1

	mov al,1
	cmp al,byte [rdul]
	jz DnRt
	mov al,2
	cmp al,byte [rdul]
	jz UpRt
	mov al,3
	cmp al,byte [rdul]
	jz UpLt
	mov al,4
	cmp al,byte [rdul]
	jz DnLt
	jmp $

print:
	push es
	push bx
	push ds
	mov ax,ds;if es is 0B800H,we can't have the word in the screen
	mov es,ax
	mov ax,msg
	mov bp,ax
	mov ax,01301h
	mov dh,12
	mov dl,40
	mov cx,8
	mov bh,0
	mov bl,byte [color]
	int 10h
	pop ds
	pop bx
	pop es
	ret

	

section .data;一开始将此模块放在section .text前时，需要再重新给dw，db数据
			;在start处赋值,同时图形中第一个A与第二个A之间停顿时间很长。
	BOOTSEG equ 0A10h
	Dn_Rt equ 1
	Up_Rt equ 2
	Up_Lt equ 3
	Dn_Lt equ 4
	delay equ 50000
	ddelay equ 580
	W equ 0FH
	R equ 04H
	Q equ 03H
	G equ 02H
	BLUE equ 01H
	sR equ 0DH
	Yel equ 0EH
	Gray equ 08H
	B equ 00H

	msg: db 'chenhyOS'
	count dw delay
	dcount dw ddelay
	rdul db Dn_Rt
	color db W
	kcolor db B
	x dw 7
	y dw 0
	char db 'A'
	kchar db '*'
times 510-($-$$) db 0 ;填充 510-($-$$) 这么多个字节的0
dw 0xaa55;结束标志