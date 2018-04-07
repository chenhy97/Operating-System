#include "use.h"
void printcircle(char alpha){
    int pos = (80 * 15 + 20)*2;
    int color = 3;
	_printchar(alpha,pos,color);
    return;
}
void showline(){
    char alpha = 'a';
    char name[6];
    name[0] = 'c';
    name[1] = 'h';
    name[2] = 'e';
    name[3] = 'n';
    name[4] = 'h';
    name[5] = 'y';
    int color = 3;
    int i = 0;
    int pos = (80 * 0 + 0)*2;
    for(i = 0;i < 6;i ++){
        pos = (80 * i + i) * 2;
        _printchar(name[i],pos,color);
    }
}
void printpos(char const* Messeage,int row,int colume){//need the pos
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
void printname(){
    char const* Message = "chenhy";
    printpos(Message,15,10);
}
