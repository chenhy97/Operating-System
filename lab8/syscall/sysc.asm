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
global _initialInt_08h
global _RunProgress
global _test
global _initialTimer
global _Get_Hours_1
global _Get_Hours_2
global _Get_Minutes_1
global _Get_Minutes_2
global _sys_stack_copy
global _save
global _fork_user
global _Schedule_once
global _Schedule
global _wait
global _exit
global _Pr
global _Vr
global _GetSem
global _FreeSem
global _Schedule_PV
extern printcircle
extern sys_showline
extern sys_printname
extern sys_printpoem
extern sys_printheart
extern sys_schedule
extern _CurrentProg
extern sys_wait
extern sys_exit
extern sys_exit_fork
extern ttime
extern do_fork
extern do_P
extern do_SemGet;
extern do_SemFree;
extern do_V;

delay equ 8
count db delay
alpha db '-'
int_09_saved dd 0
program_saved dd 112
ds_saved dd 124
return_save dw 136
esi_save dd 150
temp dw 1000
kernelesp_saved dd 180
esp_saved_inkernel dd 200
esp_saved_in_user dd 240
ss_saved_in_user dd 300
color db 1
ss_saved_fork dd 450
retaddr dd 600
Message31: dw 'time: '
MessageLength31  equ ($-Message31)

%macro newret 0;inorder to get back,have to match with enter-leave
    ;pop dword [cs:retaddr]
    ;jmp word [cs:retaddr]
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
;   复制堆栈_sys_stack_copy(old -> ss,old -> esp,newone -> ss)
;===============================
_sys_stack_copy:
    enter 0,0
    mov ss,ax
    pusha
    push ds
    mov ax,[bp + 6];old -> ss
    mov dx,[bp + 10];old -> esp
    mov cx,[bp + 14];new -> ss
    mov bx,ds
while_loop1:
    cmp dx,0x100
    jz end_for_copy
    mov ds,ax
    mov bx,word [edx]
    mov ds,cx
    mov [edx],bx
    add dx,2
    jmp while_loop1
end_for_copy:
    pop ds    
    popa
    leave
    newret
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
    push ax
    push bx
    mov ax,[bp+6] ; ASCII码
    mov ah,0eh ; 功能号
    ;mov bh,0
    mov bl,0 ; Bl设为0
    int 10H ; 调用中断
    cli
    pop bx
    pop ax
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
    mov ax, word [bp+14];内存地址
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
    mov dword [esp_saved_inkernel],esp
    call far [es:program_saved]
 S:
    mov ax,cs;返回内核时，将用户程序的ds，es改回内核程序的ds，es
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov esp,dword [esp_saved_inkernel]
    mov ah,00H
    int 16h
    leave
    newret

_Schedule_once:
    enter 0,0
    ;push word 0
    int 41h;
    leave
    newret

_fork_user:
    enter 0,0
    ;push word 0
    int 39h
    leave
    newret
_Schedule:

    enter 0,0
    push ss
    ;push word 0
    int 23h
    pop ss
    leave
    newret
_wait:
    enter 0,0
    ;push word 0
    int 3Bh
    leave 
    newret
_exit:
    enter 0,0
    mov eax,dword [ebp + 6]
    push eax
   ; push word 0
    int 2Ah
    leave
    newret
_GetSem:
    enter 0,0
    mov eax,dword [ebp + 6]
    push eax
    int 3Ch
    leave
    newret
_FreeSem:
    enter 0,0
    mov eax,dword [ebp + 6]
    push eax
    int 3Dh
    leave
    newret
_Pr:
    enter 0,0
    mov eax,dword [ebp + 6]
    push eax
    int 3Eh
    leave
    newret
_Vr:
    enter 0,0
    mov eax,dword [ebp + 6]
    push eax
    int 3Fh
    leave
    newret
_Schedule_PV:
    enter 0,0
    
    ;push word 0
    int 23h
    
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
    CLI
    push ds
    push es
    mov ax,cs
    mov ds,ax;在内核栈中做这些肮脏的交易
    mov es,ax
;is ok but we can not finish the keyboard interupt:
    mov word [ss_saved_in_user],ss
    mov ss,ax
    ;popa
   mov dword [esp_saved_in_user],esp;营造一个原有的内核栈环境给内核进行按键判断
   mov esp,dword [esp_saved_inkernel]
    push bx
    push cx
    push dx
    mov ah,01h;检测键盘状态。
    int 16h
    pop dx
    pop cx
    pop bx
   mov ss,word[ss_saved_in_user];还原用户ss,便便之后要擦屁股
   mov esp,dword[esp_saved_in_user]
    pop es
    pop ds
    jz going_on
    push ax
    mov ah,00H
    int 16h
    pop ax
    STI
    int 38h 
    iret
going_on:
    STI
    iret
 ;====================================================
;                   08h:时钟中断
;==================================================== 
_SetINT08h_turn_around:
  
    
    call _save
    CLI
    push 0
    call sys_schedule
    call _restart
    mov al,20h
    out 20h,al
    out 0A0H,al
    STI
    iret
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
    cli
    push ds
    push es
    ;push ss
    ;pusha
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
;need debug: 
    mov word [ss_saved_in_user],ss
    mov ss,ax
    mov dword [esp_saved_in_user],esp;营造一个原有的内核栈环境给内核进行按键判断
    mov esp,dword [esp_saved_inkernel]
    pusha
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
    mov ss,word[ss_saved_in_user];还原用户ss,便便之后要擦屁股
    mov esp,dword[esp_saved_in_user]
   ; pop ss
    pop es;;;位置在哪里？？？？？思考！！！！！！！！！
    pop ds
	iret
;====================================================
;                  33h：显示斜体“chenhy”
;====================================================
_SetINT33h:
    CLI
   enter 0,0
    pusha
    push ds
    push gs
    push es
    ;push ss
    mov ax,cs
    mov es,ax
    mov ds,ax
    mov word [ss_saved_in_user],ss;存在内核中
    mov ss,ax
    mov dword [esp_saved_in_user],esp;in order to protect kernel's ss and turn back to kernel
    mov esp,dword [esp_saved_inkernel]
    push word 0 ;in order to turn back to the program correctly
    call sys_showline
    mov ss,word[ss_saved_in_user];还原用户ss
    mov esp,dword[esp_saved_in_user]
    ;pop ss
    pop es
    pop gs
    pop ds
    popa
    STI
   leave
    iret
;====================================================
;                 34h：显示“I am OS”
;====================================================
_SetINT34h:
    CLI
    enter 0,0
     pusha
    push ds
    push gs
    push es
    mov ax,cs
    mov es,ax
    mov ds,ax
    mov word [ss_saved_in_user],ss;存在内核中
    mov ss,ax
    mov dword [esp_saved_in_user],esp;in order to protect kernel's ss and turn back to kernel
    mov esp,dword [esp_saved_inkernel]
    push word 0
    call sys_printname
    mov ss,word[ss_saved_in_user];还原用户ss
    mov esp,dword[esp_saved_in_user]
    pop es
    pop gs
    pop ds
    popa
    STI
    leave
    iret
;====================================================
;                35h：显示“I am test”
;====================================================
_SetINT35h:
    pusha
    push ds
    push gs
    push es
    mov ax,cs
    mov es,ax
    mov ds,ax
    mov word [ss_saved_in_user],ss;存在内核中
    mov ss,ax
    mov dword [esp_saved_in_user],esp;in order to protect kernel's ss and turn back to kernel
    mov esp,dword [esp_saved_inkernel]
    push word 0
    call sys_printpoem
    mov ss,word[ss_saved_in_user];还原用户ss
    mov esp,dword[esp_saved_in_user]
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
    mov ax,cs
    mov es,ax
    mov ds,ax
    mov word [ss_saved_in_user],ss;存在内核中
    mov ss,ax
    mov dword [esp_saved_in_user],esp;in order to protect kernel's ss and turn back to kernel
    mov esp,dword [esp_saved_inkernel]
    push word 0
    call sys_printheart
    mov ss,word[ss_saved_in_user];还原用户ss
    mov esp,dword[esp_saved_in_user]
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
   ; cmp ah,4
   ; jz fn4
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
;just for test
_SetINT37h:
    CLI
    call RTC_Timer
    iret
_SetINT38h:
    CLI
    push ax
    push ds
    mov ax,cs
    mov ds,ax
    push word 0
    call sys_exit
    pop ds
    pop ax
    STI
    iret
_SetINT39h:
    CLI
    enter 0,0
    push ds
    ;push ax
    push 0
    mov ax,cs
    mov ds,ax
    call do_fork
   ; pop ax
    pop ds
    leave
    STI
    iret
_SetINT41h:
    CLI
    call _save
    call _restart
    mov al,20h
    out 20h,al
    out 0A0H,al
    STI
    iret

_SetINT2Ah:
    CLI
    enter 0,0
    push ds
    ;push ax
    mov eax,[ebp + 8]
    push eax
    push 0
    mov ax,cs
    mov ds,ax
    call sys_exit_fork
    pop ax
    pop ds
    leave
    STI
    iret
_SetINT3Bh:
    CLI
    enter 0,0
    push ds
    ;push ax
    push 0
    mov ax,cs
    mov ds,ax
    call sys_wait
    ;pop ax
    pop ds
    leave
    STI
    iret
_SetINT3Ch:
    CLI
    enter 0,0
    push ds
    ;push ax
    mov eax,[ebp + 8]
    push eax
    push 0
    mov ax,cs
    mov ds,ax
    call do_SemGet
    ;pop ax
    add esp,4
    pop ds
    leave
    STI
    iret

_SetINT3Dh:
    CLI
    enter 0,0
    push ds
    ;push ax
    mov eax,[ebp + 8]
    push eax
    push 0
    mov ax,cs
    mov ds,ax
    call do_SemFree
    ;pop ax
    add esp,4
    pop ds
    leave
    STI
    iret

_SetINT3Eh:
    
    enter 0,0
    push ds
    ;push ax
    mov eax,[ebp + 8]
    push eax
    push 0
    mov ax,cs
    mov ds,ax
    call do_P
    ;pop ax
    add esp,4
    pop ds
    leave
   
    iret

_SetINT3Fh:
   
    enter 0,0
    push ds
    ;push ss
    ;push ax
    mov eax,[ebp + 8]
    push eax
    push 0
    mov ax,cs
    mov ds,ax
    ;mov ss,ax
    call do_V
    ;pop ax
    add esp,4
    pop ds
    ;pop ss
    leave
   
    iret
;========================================================
;                   初始化中断向量程序区
;========================================================
_initialInt:
    enter 0,0
    ;push 0;
     SetInt 20h,_SetINT20h
     SetInt 33h,_SetINT33h
     SetInt 34h,_SetINT34h
     SetInt 35h,_SetINT35h
     SetInt 36h,_SetINT36h
     SetInt 21h,_SetINT21h
     SetInt 37h,_SetINT37h
     SetInt 38h,_SetINT38h
     SetInt 39h,_SetINT39h
     SetInt 2Ah,_SetINT2Ah
     SetInt 41h,_SetINT41h
     SetInt 23h,_SetINT08h_turn_around
     SetInt 3Bh,_SetINT3Bh

     SetInt 3Ch,_SetINT3Ch
     SetInt 3Dh,_SetINT3Dh
     SetInt 3Eh,_SetINT3Eh
     SetInt 3Fh,_SetINT3Fh
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
_initialInt_08h:
    enter 0,0
    mov al,40h
    out 43h,al
    mov ax,1193182/20	; 每秒20次中断（50ms一次）
	out 40h,al				; 写计数器0的低字节
	mov al,ah				; AL=AH
	out 40h,al				; 写计数器0的高字节
    ;SetInt 08h,_SetINT08h
    SetInt 08h,_SetINT08h_turn_around
	leave
    newret

_save:
    mov dword [esp_saved_inkernel],esp;//new added,in order to enable interupt
    push ds;用户ds
    push cs;
    pop ds
    pop word [ds_saved]
    pop word [return_save]
   ; mov word [ss_saved_fork],ss
    mov dword [kernelesp_saved],esp
    mov dword [esi_save],esi
    mov esi,dword [_CurrentProg]
    add esi,44
    pop word [esi];save eip
    ;mov word [esi+2],0
    pop word [esi+4];save cs
    mov word [esi+6],0
    pop word [esi+8];save eflags
    mov word [esi+10],0
    mov dword [esi - 4],esp
    mov word [esi - 8],ss
    mov si,ds
    mov ss,si
    mov esp,dword [_CurrentProg]; mov esp, dword ptr ds:0x9d40
    add esp,36
    push word 0
    push word [ds_saved]
    push word 0
    push es
    push ebp
    push edi
    push dword [esi_save]
    push edx
    push ecx
    push ebx
    push eax
   ; mov ss,word [ss_saved_fork]
    mov esp,dword [kernelesp_saved];：：：：：：：：：：：：：：：：：：：：：在进入用户程序的时候先保存kernelsp！?????
    mov ax,word [return_save]
    jmp ax
_restart:
;TODO:
    ;add blocked state
    ;if current_prg.state = blocked
    ;wait for run() toiret
    mov dword [kernelesp_saved],esp
    mov esp,dword [_CurrentProg]
    pop eax
    pop ebx
    pop ecx
    pop edx
    pop esi
    pop edi
    pop ebp
    pop es;系统数据段
    pop word [temp];in order to balance
    pop word [ds_saved]
    pop word [temp];in order to balance
    mov dword [esi_save],esi;ds is the kernel'ds
    pop ss
    pop word [temp];in order to balance
    mov esi,esp;between ss and esp,the next one is esp
    mov esp,dword [esi];把esp的存着的值给esp
    push word [esi + 12];eflags
    push word [esi + 8];cs
    push word [esi + 4];eip
    mov esi,dword [esi_save]
    mov ds,word [ds_saved]
    push ax
    mov al,20h
    out 20h,al
    out 0A0H,al
    pop ax
    iret
;********
;时间函数
;**********
RTC_Timer:
    enter 0,0
    push ds
    push es
	pusha
    mov  ax,  cs
	mov  ds,  ax           ; DS = CS
    mov  ax,  cs
	mov  es,  ax           ; ES = Cs
	
    mov di, ttime
	
	mov ah,02h
    int 1Ah
    mov al,ch
	mov ah,0
	mov bl,16
	div bl
	add al,30h
	mov byte [di],al

    mov ah,02h
    int 1Ah
    mov al,ch
    and al,0fh
    add al,30h
	mov [di+1],al
    mov byte [di+2],' '
    mov byte [di+3],'h'
	mov byte [di+4],' '

	mov ah,02h
    int 1Ah
    mov al,cl
	mov ah,0
	mov bl,16
	div bl
	add al,30h
	mov byte [di+5],al

     mov ah,02h
     int 1Ah
     mov al,cl
     and al,0fh
     add al,30h
	mov byte [di+6],al
    mov byte [di+7],' '
    mov byte [di+8],'m'
	mov byte [di+9],' '
    mov  ax,  cs
	mov  ds,  ax           ; DS = CS
	mov  es,  ax           ; ES = CS	
	mov	bp, Message31		 ; BP=当前串的偏移地址
	mov	ax, ds		 ; ES:BP = 串地址
	mov	es, ax		 ; 置ES=DS
	mov	cx, MessageLength31 ; CX = 串长（=9）
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 000fh		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)
    mov 	dh, 10		       ; 行号=0
	mov	dl, 10			 ; 列号=0
	int	10h			 ; BIOS的10h功能：显示一行

    mov  ax,  cs
	mov  ds,  ax           ; DS = CS
	mov  es,  ax           ; ES = CS
	mov	bp, ttime ; BP=当前串的偏移地址
	mov	ax, ds			    ; ES:BP = 串地址
	mov	es, ax			    ; 置ES=DS 
	mov	 cx, 15         	; CX = 串长（=10）
	mov	 ax, 1301h	 
	; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	 bx, 000fh
	; 页号为0(BH = 0) 黑底白字(BL = 07h)
	mov  dh, 10		; 行号=10
	mov	 dl, 30		; 列号=10
	int	10h		; BIOS的10h功能：显示一行字符
    popa
    pop es
    pop ds
    leave
	newret

_Get_Hours_1:
    enter 4,0
	mov ah,02h
    int 1Ah
    mov al,ch
	mov ah,0
	mov bl,16
	div bl
	;add al,30h
	xor ah,ah
    mov [esp],eax
    mov eax,[esp]
    leave
    newret

_Get_Hours_2:
    enter 4,0
    mov ah,02h
    int 1Ah
    mov al,ch
    and al,0fh
    ;add al,30h
    xor ah,ah
    mov [esp],eax
    mov eax,[esp];save the output by this way
    leave
    newret

_Get_Minutes_1:
    enter 4,0
    mov ah,02h
    int 1Ah
    mov al,cl
	mov ah,0
	mov bl,16
	div bl
    xor ah,ah
    mov [esp],eax
    mov eax,[esp];save the output by this way
    leave
    newret

_Get_Minutes_2:
    enter 4,0
    mov ah,02h
    int 1Ah
    mov al,cl
    and al,0fh
    xor ah,ah
	mov [esp],eax
    mov eax,[esp];save the output by this way
    leave
    newret
    

    
    

    