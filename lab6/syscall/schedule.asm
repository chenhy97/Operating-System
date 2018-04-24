_save:
    mov dword [esp_saved_inkernel],esp;//new added,in order to enable interupt
    push ds;用户ds
    push cs;
    pop ds
    pop word [ds_saved]
    pop word [return_save]
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