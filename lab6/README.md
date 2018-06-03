# 进程切换
------------
实现多个进程相互切换，交替运行
## TODO_list & Questions:
- [x] 进程被安置在不同的段
- [x] save,restart,schedule的理解，过程示例图
- [x] 用户进程栈，内核栈，内核进程栈分离
- [x] 指针声明好坑啊。。。。CurrentPCB与PCBList在内存中的 		关系，代表意义
- [x] 利用非时钟中断可以实现进程TEST切换到进程A了
- [x] 通过时钟中断实现了切换
- [x] bug:由于初始化PCB函数的问题，无法运行进程1或进程4，没有注意下标
- [x] 记得寄存器在PCB中的位置就是实际上在内存中的位置，顺序要保证
- [x] 实现了__返回内核__,解决方法暂时只能利用一开始栈切换时save的那些寄存器，当要返回时切回那个栈，恢复寄存器即可
- [ ] 时钟中断和内核是并行的？？？？
- [ ] 进程ABCD在运行时，实际上有可能在执行自己的内核？
 	- 我的内核在运行完程序之后会等待用户输入，当用户进程在执行时输入的东西会在内核里面显示。
- [ ]  分离底层汇编文件。sysc.asm -> schedule.asm+sysc.asm+interupt.asm
- [ ] 实现了系统时钟显示功能。
- [ ] ctime库
