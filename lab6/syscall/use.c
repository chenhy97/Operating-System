#include "use.h"
#include "schedule.h"
//====================================================
//                封装清屏函数
//====================================================
void clearscreen(){
	_clearscreen();//C调用汇编时会压入四个字节，必须考虑到这个，写出newret，是pop edx,而非 pop dx；
	//__asm__("pop %ax");
	return ;
}

//*****************************************************************************************
//
//			未调试区（读磁盘用户程序函数）
//
//*****************************************************************************************
/*void buildmap(){
    struct info map;
    strcpy("1.img",map.name[0]);
	map.size[0] = 512;
	map.sector[0] = 23;
	strcpy("2.img",map.name[1]);
	map.size[1] = 512;
	map.sector[1] = 25;
	 strcpy("3.img",map.name[2]);
	map.size[2] = 512;
	map.sector[2] = 27;
	 strcpy("4.img",map.name[3]);
	map.size[3] = 512;
	map.sector[3] = 29;
	map.num = 4;
	_write(2,21,&map);
}
void showtable(){
	struct info* map = (struct info*)0xb100;
	int i = 0;
	prints("\n\r");
	for(i = 0;i < map->num;i++){
		prints(map->name[i]);
		printsint(map->size[i]);
		printsint(map->sector[i]);
		prints("\n\r");
	}
}*/
//====================================================
//                封装中断初始化函数
//====================================================
void Initial_Int(){
	_initialInt();
	return;
}
void Initial_Int_09h(){
	_initialInt_09h();
}
void Initial_Int_08h(){
	_initialInt_08h();
}
void loadProg(int count,int begin,int memory_postion){
    _loadP(count,begin,memory_postion);
}