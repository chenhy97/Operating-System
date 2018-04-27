#include "use.h"
char ttime[20]="";
void sys_print_for_heart(char const* Messeage,int row,int colume){//need the pos
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
void sys_print_different_color(char const* Messeage,int row,int colume,int color){
    int pos = (80 * row + colume)*2;
	int index = 0;
	while(Messeage[index] != '\0'){
		_printchar(Messeage[index],pos,color);
		index++;
		pos = pos + 2;
	}
	return;
}
void sys_showline(){
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

void sys_printname(){
    char const* Messeage1 = "***      ***  *****     *****         ******                ****  ";
    char const* Messeage2 = "***      ***   ****     ****       ***      ***          **     ** ";
    char const* Messeage3 = "***      ***    ***     ***      ***          ***       **         "; 
    char const* Messeage4 = "************       *****         ***          ***         ***      ";
    char const* Messeage5 = "***      ***       *****         ***          ***            **    ";
    char const* Messeage6 = "***      ***       *****           ***      ***          **   ***  ";
    char const* Messeage7 = "***      ***       *****              ******               ****    ";

    sys_print_for_heart(Messeage1,16,11);
    sys_print_for_heart(Messeage2,17,11);
    sys_print_for_heart(Messeage3,18,11);
    sys_print_for_heart(Messeage4,19,11);
    sys_print_for_heart(Messeage5,20,11);
    sys_print_for_heart(Messeage6,21,11);
    sys_print_for_heart(Messeage7,22,11);
}
void sys_printpoem(){
    char const* Messeage = "Comuputer Sciense";
    char const* Messeage2 = "chenhyOS";
    int i = 1;
    for(i = 1;i < 7;i ++){
        sys_print_different_color(Messeage,15,10,i);
        sys_print_different_color(Messeage2,16,10,i);
        int j = 0;
        int k = 0;
    }
}
void sys_printheart(){
    sys_print_for_heart("     * *       * *     ",00,40);
    sys_print_for_heart("   * * * *   * * * *    ",1,40);
    sys_print_for_heart(" * * * * * * * * * * *    ",2,40);
    sys_print_for_heart("  * * * * * * * * * *   ",3,40);
    sys_print_for_heart("    * * * * * * * *    ",4,40);
    sys_print_for_heart("      * * * * * *     ",5,40);
    sys_print_for_heart("        * * * *      ",6,40);
    sys_print_for_heart("          * *       ",7,40);
}