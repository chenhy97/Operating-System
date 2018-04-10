;org 0A100h
;init
[BITS 16]
[global user4]
user4:
mov	ax, cs	       ; 置其他段寄存器值与CS相同
mov	ds, ax
mov ax,0B800h
mov es,ax
%macro POINT 6
	mov ax, [%1]
	mov [x],ax
	mov ax,[%2]
	mov [y],ax
	mov al,[%3]
	mov [xdul],al
	mov al,[%4]
	mov [ydul],al
	mov al,[%5]
	mov [color],al
	mov al,[%6]
	mov [char],al

	call move
	inc byte [color]
	mov ax, [x]
	mov [%1], ax
	mov ax, [y]
	mov [%2], ax
	mov al, [xdul]
	mov [%3], al
	mov al, [ydul]
	mov [%4], al
	mov al,[color]
	mov [%5],al
%endmacro
start:
	call loop1
	POINT x1,y1,xdul1,ydul1,color1,char1
	;POINT x2,y2,xdul2,ydul2,color2,char2
	call showname
	int 20h
	jmp start


move:
;call Setpoint
;call kill
call update
call Setpoint
call show
;call Enter
ret

update:
mov al,byte [xdul]
call handlex
mov al,byte [ydul]
call handley
ret
handlex:
	cmp al,1
	jnz dec1
	inc word [x]
	cmp word [x],25
	jnz notchange
	mov word [x],23
	mov byte [xdul],0
	ret
dec1:
	dec word [x]
	cmp word [x],12
	jnz notchange
	mov word [x],14
	mov byte [xdul],1
	ret

handley:
	cmp al,1
	jnz dec2
	inc word [y]
	cmp word [y],80
	jnz notchange
	mov word [y],78
	mov byte [ydul],0
	ret
dec2:
	dec word [y]
	cmp word [y],39
	jnz notchange
	mov word [y],41
	mov byte [ydul],1
notchange:
	ret

Setpoint:
	xor ax,ax
	mov ax,word [x]
	mov bx,80
	mul bx
	add ax,word [y]
	mov bx,2
	mul bx
	mov bx,ax
	ret
show:
	mov ah,byte [color]
	mov al,byte [char]
	mov [es:bx],ax	
	mov bl,byte [color]
	cmp bl,10H
	jnz c
	mov bl,01H
	mov byte [color],bl
c:
	ret
kill:
	mov ax, 0
	mov [es:bx],ax
	ret

loop1:
	mov cx, word [count]
	LOOP1:
		mov ax, word [dcount]	
		LOOP2:
			dec ax
			jg LOOP2
	loop LOOP1
	ret
showname:
	push es
	push bx
    push ebp
	mov	ax, ds		 ; ES:BP = 串地址
	mov	es, ax
	mov ax,msg
	mov bp,ax
	mov ax,01301h
	mov dh,12
	mov dl,40
	mov cx,8
	mov bh,0
	mov bl,[color]
	int 10h
    pop ebp
	pop bx
	pop es
	ret
;Enter:
;	mov ah,1
;	int 16h
;	jnz back
;	ret

;back:
;	cmp al,'q'
;	jnz h
;	mov ah,0
;	int 16h
;h:
;	jmp 0:BOOTSEG2;返回监控程序
section .data
	BOOTSEG equ 0A10h
	BOOTSEG2 equ 07c00H
	xdul db 1
	ydul db 1
	x dw 7
	y dw 0

	xdul1 db 1
	ydul1 db 1
	x1 dw 15
	y1 dw 40
	color1 db sR
	char1 db 'A'

	xdul2 db 1
	ydul2 db 0
	x2 dw 24
	y2 dw 79
	color2 db Gray
	char2 db '*'

	W equ 0FH
	R equ 04H
	Q equ 03H
	G equ 02H
	BLUE equ 01H
	sR equ 0DH
	Yel equ 0EH
	Gray equ 08H
	B equ 00H

	delay equ 50000
	ddelay equ 2000
	count dw delay
	dcount dw ddelay
	msg: db 'chenhyOS'
	color db W
	char db 'A'