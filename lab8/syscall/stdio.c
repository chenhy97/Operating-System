#include "stdio.h"
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
char getch(){
	char result = _readinput();
	return result;
}
void  getline(char str[],int length){
	char save = getch();
	int index = 0;
	while(save != 13 && index < length){
		printc(save);
		str[index] = save;
		index ++;
		str[index] = 0;
		save = getch();
	}
	return;
}
void print_different_color(char const* Messeage,int row,int colume,int color){
    int pos = (80 * row + colume)*2;
	int index = 0;
	while(Messeage[index] != '\0'){
		_printchar(Messeage[index],pos,color);
		index++;
		pos = pos + 2;
	}
	return;
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