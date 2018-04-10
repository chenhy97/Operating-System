#include "use.h"
void printpos(char const* Messeage,int row,int colume){//Why need this???
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
void print_for_heart(char const* Messeage,int row,int colume){//need the pos
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
void printname(){
    char const* Messeage = "I am OS";
    print_for_heart(Messeage,16,11);

}
void printpoem(){
    char const* Messeage = "I am test";
    print_for_heart(Messeage,15,10);
}
void printheart(){
    print_for_heart("     * *       * *     ",10,00);
    print_for_heart("   * * * *   * * * *    ",11,00);
    print_for_heart(" * * * * * * * * * * *    ",12,00);
    print_for_heart("  * * * * * * * * * *   ",13,00);
    print_for_heart("    * * * * * * * *    ",14,00);
    print_for_heart("      * * * * * *     ",15,00);
    print_for_heart("        * * * *      ",16,00);
    print_for_heart("          * *       ",17,00);
}