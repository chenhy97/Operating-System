#include "use.h"
//====================================================
//                封装清屏函数
//====================================================
void clearscreen(){
	_clearscreen();//C调用汇编时会压入四个字节，必须考虑到这个，写出newret，是pop edx,而非 pop dx；
	//__asm__("pop %ax");
	return ;
}
//====================================================
//              显示字符串函数，可以指定位置
//====================================================
void print(char const* Messeage,int row,int colume){//need the pos
	int pos = (80 * row + colume)*2;
	int color = 3;
	int index = 0;
	while(Messeage[index] != '\0'){
		_printchar(Messeage[index],pos,color);
		index++;
		pos = pos + 2;
	}
	return;
}
//====================================================
//               显示字符串函数，紧跟着光标
//====================================================
void prints(char const *Messeage){//can follow the position of your input
	int index = 0;
	while(Messeage[index]){
		_showchar(Messeage[index]);
		index++;
	}
	return;
}
//====================================================
//                显示字符函数
//====================================================
void printc(char alpha){
	_showchar(alpha);
	return;
}
//====================================================
//                数字转字符函数
//====================================================
void printsint(int num){
	 int save = num;
	 int count = 0;
	 char number[30];
	 number[count] = 0;
	if(num < 0){
		printc('-');
		num = -num;
	}
	else if(num == 0){
		printc('0');
	}
	while(num > 0){
		number[count] = num % 10 + '0';
		num  = num / 10;
		count ++;
	}
	int i;
	for(i = count - 1;i >= 0;i --){
		printc(number[i]);
	}
	return;
}
//====================================================
//                显示字符串并换行函数
//====================================================
 void print_next_line(char const* Messeage){
	prints(Messeage);
	prints("\n\r");
	return;
}
//====================================================
//               获取字符串长度函数
//====================================================
 int strlen(char const *Messeage){
	int i = 0;
	int count = 0;
	while(Messeage[i] != 0){
		i++;
		count++;
	}
	return count;
}
//====================================================
//                读取用户输入并回显函数
//====================================================
 void read_and_print_input(){
    int i = 1;
    while(i){
        char savechar = _readinput();
        _showchar(savechar);
    }
}
//====================================================
//        等待用户输入函数，返回用户输入在缓冲区中
//====================================================
 char waitforinput(){
	char result = _readinput();
	return result;
}
//====================================================
//                字符串匹配函数
//====================================================
int strcmp(char *m1,char const* m2){
	int i = 0;
	while(m1[i] != 0 && m2[i]!= 0){
		if(m1[i] != m2[i]){
			return 0;
		}
		i++;
	}
	if(m1[i] != 0 || m2[i] != 0){
		return 0;
	}
	return 1;
}
//====================================================
//                字符串复制函数
//====================================================
void strcpy(char const *src,char *des){
	int len = strlen(src);
	int i = 0;
	for(i = 0;i < len;i ++){
    	des[i] =  src[i];
        des[i+1] = 0;
	}
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