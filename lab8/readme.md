#实验八：进程同步机制
##	实验目的
-	了解并掌握用于同步、互斥的计数信号量机制
##	实验要求
##	实验方案
###1.实验环境
###2.实验工具
###3.总体思路

##具体实现
###1.	新增信号量Semaphone结构

###2.	Semaphone相关函数的实现

###3.	新增队列结构，实现管理队列的函数。

###4.	新的schedule函数

###5.	SemGet函数实现

###6.	SemFree函数实现

###7.	do_P原语实现

###8.	do_V原语实现

###9.	展示程序的实现

##实验难点和解决方案
-	局部变量很有毒
- 	系统调用的实现
-  
##实验效果截图

##实验感想
-	就绪队列
- 	运行队列？？？
- 	阻塞队列
-  信号量列表
-  P、V操作
-  how to use 就绪队列？
	-	首先在调度器中，遍历一遍进程数组，无运行进程时，从就绪队列中FIFO选出一个做为运行进程
-	局部变量贼几把有毒