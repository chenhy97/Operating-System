#进程控制与通信
##实验目的
1.	在内核实现多进程的五状态模型，理解进程的创建、退出过程。

2.	实现父子进程的相互通信。
3. 	 完善进程模型，进程可以按需产生子进程，一组进程分工合作，并发运行，各自完成一定工作。同时在并发的过程中，协调一些事件的时序，实现简单的同步。

##实验要求
1.	设计满足下列要求的新原型操作系统：
	-	实现控制的基本原语do\_fork()、 do\_wait()、do\_exit()、blocked()和wakeup()。
	
	-	内核实现三系统调用fork()、 wait()和exit() ，并在c库中封装相关的系统调用.
	-	编写一个c语言程序，实现多进程合作的应用程序。
2.	设计一个多进程的应用程序，验证父子进程是否可以正确的相互通信。

##实验方案
###1.实验环境
-	实验运行环境:MacOS
	
-	调试用虚拟机:bochs
	
-	虚拟机软件:VMware Fusion

###2.实验工具

-	汇编语言:NASM汇编语言 C语言
	
-	编译器:gcc 4.9.2
	
-	链接工具:GNU ld
	
-	反汇编工具：ObjDump
	
-	构建工具:GNU make语言
	
-	调试工具:Bochs
	
-	合并bin文件到统一磁盘映像工具：dd

###3.实验架构
![](树状结构.png)
###4.总体思路
-	为了完成进程的创建、退出与调度。首先最重要的，是要完成fork、wait和exit。在这三个函数的最后，我们都应该使用调度函数来进行父子进程的相互切换。

- 	进程在调用进程创建之后会完成如下的转换：
	-	首先是在内存中开辟一个PCB块，提供给子进程。然后完成父子进程PCB以及堆栈的统一，然后使用调度函数，恢复父进程，继续执行。
	
	-	然后在父进程中继续执行，知道执行到wait函数，wait函数的作用有两个，其一是阻塞当前检测，其二是调度进程，使子进程开始执行。
	
	-	子进程会在父进程fork的IP保存点处重新开始执行，关于IP的选定会在fork的具体实现中说明。子进程在执行到exit的时候将自己的状态置为退出态，然后调度函数回到父进程。

##具体实现
###1.PCB新增结构
-	由于每次创建进程的时候，我们都会创建出一个处于就绪态的进程；每次进程等待时，会阻塞当前状态，所以我们必须增加多两个状态为就绪态与阻塞态。

- 	为了实现fork函数，我们必须记录每个进程的ID以及他的父进程ID，以便子进程结束之后，找到父进程的PCB进行恢复并切换。

-	最后PCB的结构如下：

	```cpp
		struct PCB{
    		unsigned int eax;
   			unsigned int ebx;
    		unsigned int ecx;
    		unsigned int edx;
    		unsigned int esi;
    		unsigned int edi;
    		unsigned int ebp;
    		int es;
    		int ds;
    		int ss;
    		unsigned int esp;
    		int ip;
    		int cs;
    		int eflags;
    		int prg_status ;
    		int id;
    		int fid;
		};
	```
	
###2.do_fork实现
-	每次调用do_fork的时候,我们需要执行如下操作：
	- 必须在PCB结构数组中找到一个空闲的PCB块，将其作为子进程的PCB。
	
	- 在选定了子进程PCB块之后，我们需要将父进程的PCB复制给子进程，然后将父进程的堆栈复制给子进程。但是必须注意，为了保证复制给子进程的PCB块是最新的，因此我们在调用PCB_copy之前需要先刷新父进程PCB。
	- 注意到由于调用fork之后，父子进程是虽然是完全相同的PCB块内容与堆栈内容，但是父子进程并不是共享同一个PCB块与堆栈块，因此需要另外给子进程安排堆栈位置。不过需要注意的是他们共享代码段以及数据段。而且子进程的状态此时为就绪态。
	- 最后需要注意的是子进程IP的选择。因为最后进程切换的时候，子进程必须恢复到一个不会将影响到原来子进程堆栈内容、寄存器内容的IP中（否则，就会得到不同的结果），因此在父进程向子进程复制IP之前我先调用save函数，刷新父进程PCB中的IP，这样子进程接下来执行的指令就不会影响程序的正常执行内容。
	- 最后我们通过判断进程ID可以区分父子进程，并返回正确的值。
-	重要代码实现：

```cpp
int do_fork(){
   struct PCB* fork_prg;
    fork_prg = PCB_list + 1;
    while(fork_prg < PCB_list+PCB_NUMMER && fork_prg -> prg_status == RUN )    fork_prg = fork_prg + 1;//应该增加used位，防止被覆盖
    if(fork_prg > PCB_list+(PCB_NUMMER - 1)) _CurrentProg -> eax = -1;
    else{
        _Schedule_once();
        __asm__("sub $6,%esp");
        pcb_copy(_CurrentProg,fork_prg);//copy PCB
        __asm__("add $6,%esp");
        fork_prg -> id = (fork_prg - PCB_list);//id = 44,是否有问题？？？
        fork_prg -> fid = _CurrentProg - PCB_list;
        fork_prg -> ds = _CurrentProg -> ds;
        fork_prg -> ss = 0x2000 + 0x1000 * (fork_prg - PCB_list);
        fork_prg -> cs = _CurrentProg -> cs;
        fork_prg -> prg_status = READY;
       // __asm__("enter $0,$0");
        _Schedule_once();
        __asm__("sub $6,%esp");
        _sys_stack_copy(_CurrentProg -> ss,_CurrentProg -> esp,fork_prg -> ss);
        __asm__("add $6,%esp");
        fork_prg -> ip = _CurrentProg -> ip;
        fork_prg -> eax = 0;
        if(fork_prg == _CurrentProg){
            return 0;
        }
        _CurrentProg -> eax = fork_prg -> id;
        return _CurrentProg -> eax;
    }
}
```
	
###3.stack\_copy以及PCB_copy实现
-	PCB_copy实现，其实就只是将父进程的所有通用寄存器复制给子进程，然后复制ds、es、cs，最后复制标志寄存器eflags。要注意的是，堆栈段和IP必须另外处理。

- 	stack_copy实现：由于我为用户程序分配堆栈规定分配在每个用户程序堆栈的前0x100单元，所以直接使用汇编代码，将父进程的前0x100堆栈中的内容复制到子进程中。

###4.schedule的进化实现
-	由于之前的调度器，为了实现四个进程之间的交替轮转，只涉及两个状态，所以调度器实现的思路是轮流判断四个进程的状态，当进程为运行态时，执行进程。

- 这一次调度，涉及多了两个状态，特别是对于就绪态向运行态的转化。我实现的思路是这样的，首先先判断所有PCB块中存下的进程的状态，然后记录一个处于就绪态的进程的序号。如果所有进程都没有一个处于运行态，则将该被选的就绪态进程置为运行态，然后执行该进程。

-	最后如果没有一个进程处于运行态或就绪态，就将执行内核程序。

-	代码如下：

```cpp
void sys_schedule(){
    int i,j;
    int index = -1;
    i = _CurrentProg - PCB_list;
    for(j = 0;j < PCB_NUMMER;j ++){
        if(i == PCB_NUMMER - 1){
            _CurrentProg = PCB_list + 1;
            i = 1;
        }
        else{
            _CurrentProg ++;
            i ++;
        }
        if(_CurrentProg -> prg_status == RUN){
            return;
        }
        if(_CurrentProg -> prg_status == READY && index == -1){
           index = _CurrentProg - PCB_list;
        }
    }
    if(index != -1){
        _CurrentProg = PCB_list + index;
        PCB_list[index].prg_status = RUN;
        return;
    }
    _CurrentProg = PCB_list ;
    return;
}
```

###5.block原语实现：
-	将指定进程的状态置为阻塞态。
- 	在调用此原语时必须关闭中断，将其作为原子操作。
-  代码如下：

	```cpp
		void sys_bolocked(int index){
    		__asm__("cli\n");
   			PCB_list[index].prg_status = BLOCKED;
    		__asm__("sti\n");
		}
	```
	
###6.wakeup原语实现：
-	将指定进程状态置为就绪态
- 	在调用此原语时必须关闭中断，将其作为原子操作。防止发生竞争。
-  代码如下：

	```cpp
		void sys_wakeup(int index){
    		__asm__("cli\n");
    		PCB_list[index].prg_status = READY;
    		__asm__("sti\n");
		}
	```
	
###7.sys_wait实现
-	wait函数需要执行的功能有三个，一个是调用block原语，阻塞当前进程，第二个就是调用调度函数，最后是返值。

- 	阻塞当前进程，直接将当前进程状态置为阻塞态即可。
-  调度函数（Schedule）其实显示调用时钟中断，保存当前PCB、选择下一个执行进程，开始执行。
-  最后返值，是将子进程中的exit传来的参数，返回到父进程中。注意的是，返值都是放在寄存器eax中的，所以直接读取eax即可。
-	代码如下:

```cpp
int sys_wait(){
    int index = _CurrentProg - PCB_list;
    sys_bolocked(index);
    _Schedule();
    return _CurrentProg -> eax;
}
```
###8.sys_exit实现
-	exit需要执行的功能:杀死当前进程，调用wakeup原语将父进程置为就绪态，将参数存入父进程PCB中的eax寄存器中，然后调用调度函数，调度回父进程。

-	代码如下：

```cpp
void sys_exit_fork(char ch){
    int index = _CurrentProg -> fid;
    sys_wakeup(index);
    PCB_list[_CurrentProg -> fid].eax = ch;
    _CurrentProg -> prg_status = EXIT;
    _Schedule();
}
```
###9.封装do\_fork、sys\_wait和sys_exit，在用户程序中使用fork、wait、exit调用
-	由于do\_fork, sys_wait, sys\_exit这三个函数都是在内核中执行的，所以是用户程序调用fork、wait、exit这三个函数的时候必须进行从用户态到内核态的转换。

- 	封装的过程如下，首先使用中断来调用do\_fork、sys\_wait、sys\_exit,然后使用_fork、\_wait、\_exit来调用这三个中断，最后使用fork、wait、exit来调用这三个函数。
-  然后在中断调用do\_fork, sys\_wait, sys\_exit这三个函数之前我们需要完成数据段的转换，转换为内核数据段。为什么要使用内核数据段呢？因为我们的PCB以及_CurrentProg是存在内核中的，所以为了使用到这两个变量，我们需要使用内核数据段。
-	以fork函数为例，进行代码说明：
	-	fork调用_fork:
	
		```cpp
			int fork(){
    		int a = _fork_user();
    		return a;
			}
		```
	-	_fork调用中断：
		
		```nasm
			_fork_user:
    			enter 0,0
    			int 39h
    			leave
    			newret
    	```
    -	中断调用_do\_fork,在这里完成内核数据段转换:
    
    	```nasm
    		_SetINT39h:
    			CLI
    			enter 0,0
    			push ds
    			push 0
    			mov ax,cs
    			mov ds,ax
    			call do_fork
    			pop ds
    			leave
    			iret
    	```
    	
##实验难点和解决方案
###1.内核大于18个扇区的bug
-	一开始在扩展内核程序，将所编写的fork文件链接到内核的时候，总是会出现进程交替模型运行不正常的情况，一直检查，怀疑了很多原因。最后才发现由于内核程序太大，超过了18个扇区，而引导程序加载内核的时候只是加载了18个扇区，因而造成了运行不正常。

- 	最后根据18个扇区换一个磁头，2个磁头换一个柱面的方式读取了虚拟软盘上的内核代码，解决问题。

###2.fork、wait的返值问题、wait的读取
-	因为fork函数会返回当前进程id，而w父进程调用wait时，会读取由子进程传来的参数。而在C代码中，我们约定将函数返回值放在eax寄存器中，每次返回时只需要将需要返回的值放在eax寄存器中即可。

- 	在fork函数中，由于我们可能会根据不同的当前进程返回不同的值。所以在父进程fork的时候，我们一定要先将正确的值存入父进程和子进程的PCB中（父进程eax存子进程id，子进程eax存0）。最后进程切换之后根据当前进程PCB中的eax寄存器中的值返值即可。
-  而在wait函数中，父进程会在子进程结束后等待子进程的返值，而子进程的返值会直接存入父进程PCB中的eax寄存器中。所以wait函数可以直接在父进程的eax寄存器中读取返值，并返回即可。

###3.exit传参问题、与系统的多重调用共同结合
-	由于exit函数是提供给用户程序进行调用的，而exit函数中又涉及了多重调用（一直调用到sys_exit,内核系统调用），所以我们必须处理好参数传递的问题。我采取的方法是每次调用之前都将参数取出再重新压栈。

- 	最后在sys_exit中将参数放入父进程PCB的eax寄存器中。

###4.返回IP丢失
-	在实现do_fork函数的过程中，遇到这样一个问题，就是在父进程调用wait函数切换到子进程的时候，无法从内核中正确切换到用户程序。
- 	最后跟踪程序，发现是do_fork函数中调用PCB\_copy和stack_copy，传参时，由于汇编在传参时是用压栈的方式进行传参的，所以在压栈的过程中将程序的返回地址覆盖了。导致子进程运行到同样的位置之后无法跳出内核调用返回用户程序。
-  最后解决方式是使用内联汇编，将压栈的位置改变，防止覆盖栈中调用函数的返回地址。
-	代码如下：

	```cpp
		 __asm__("sub $6,%esp");
        pcb_copy(_CurrentProg,fork_prg);//copy PCB
        __asm__("add $6,%esp");
    ```
    
##实验效果截图
-	用户进程的进程ID为6，用户程序中子进程测试的时候字符串"Il10abcd"的字母总数。然后返回给父进程

- 最后程序截图如下
![](photo.png)

##实验感想
-	这一次的实验其实在想好了父进程创建子进程之后的执行过程以后，是不难实现的。但是在一开始实现的时候，由于在写操作系统的初期并没有写好引导程序加载内核的程序，导致这个问题坑了我1天，在最后阶段才发现了自己只加载了18个内核扇区。

- 	在实现的时候主要难点是父进程IP的保存，当时我现在草稿纸上将整个fork执行流程画了出来，帮助我想清楚了这个问题。想好了内核执行过程之后实现是非常简单的事情，

-	由于使用了多层函数调用最后切换到内核状态的do_fork中，所以我们要注意对每次函数的返回地址进行妥善的保护，在这次实验中，就是出现过这种问题，导致我返回的时候程序跳转到一个奇怪的位置。在发现了这个问题之后使用内联汇编保护堆栈中的返回地址后解决了这个问题。