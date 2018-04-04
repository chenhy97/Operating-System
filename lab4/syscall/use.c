#include "use.h"
void clearscreen(){
	_clearscreen();//C调用汇编时会压入四个字节，必须考虑到这个，写出newret，是pop edx,而非 pop dx；
	//__asm__("pop %ax");
	return ;
}
void print(char const* Messeage,int row,int colume){//need the pos
	int pos = (80 * row + colume)*2;
	int color = 3;
	int index = 0;
	while(Messeage[index] != '\0'){
		_printchar(Messeage[index],pos,color);
		index++;
		pos = pos + 2;
	}
}
void prints(char const *Messeage){//can follow the position of your input
	int index = 0;
	while(Messeage[index]){
		_showchar(Messeage[index]);
		index++;
	}
	return;
}
void printc(char alpha){
	_showchar(alpha);
}
void printsint(int num){
	 int save = num;
	 int count = 0;
	 char number[30];
	if(num < 0){
		printc('-');
		num = -num;
	}
	if(num == 0){
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
}
 void print_next_line(char const* Messeage){
	prints(Messeage);
	prints("\n\r");
	return;
}
 int strlen(char const *Messeage){
	int i = 0;
	int count = 0;
	while(Messeage[i] != 0){
		i++;
		count++;
	}
	return count;
}
 void read_and_print_input(){
    int i = 1;
    while(i){
        char savechar = _readinput();
        _showchar(savechar);
    }
}
 char waitforinput(){
	char result = _readinput();
	return result;
}
int strcmp(char *m1,char const* m2){
	/*int len1 = strlen(m1);
	int len2 = strlen(m2);
	if(len1 != len2){
		return 0;
	}
	int i= 0;
	for(i = 0;i < len1;i++){
		if(m1[i] != m2[i]){
			return 0;
		}
	}
	return 1;*/
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
void strcpy(char const *src,char *des){
	int len = strlen(src);
	int i = 0;
	for(i = 0;i < len;i ++){
    	des[i] =  src[i];
        des[i+1] = 0;
	}
}
void buildmap(){
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
}
void Initial_Int(){
	_initialInt();
	return;
}