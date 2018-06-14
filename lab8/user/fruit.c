#include "../syscall/fork.h"
#include "../syscall/stdio.h"
int s;
int i,j,k;
char *words;
int word_index;
int fruit_disk;
int pid1,pid2;
int main(){
    __asm__("mov $0x9000, %eax\n");
    __asm__("mov %ax, %ds\n");
    __asm__("mov %ax, %es\n");
    __asm__("mov %ax, %ss\n");
    __asm__("mov $0x100, %esp");  
    s=GetSem(1);
    fruit_disk = 0;
    pid1 = fork();
    if (pid1){
        for(i = 0;i < 12;i ++) { 
            P(s); 
            //P(s); 
            prints("words: ");
            //myprintf(words);
            prints(" fruit: ");
            printsint(fruit_disk);
        }
    }
    else{ 
        prints("hehe ");
       // pid2 = fork();  
        //if(pid2){
          //  for(j = 0;j < 17;j ++) { 
           //     prints("fuck");
            //    putwords("father live forever"); 
             //   V(s);
           // }
        //}
        //else{
            for(k = 0;k < 17;k ++) { 
                prints("you");
                fruit_disk = fruit_disk + 1;
                V(s);
                delay();
                //_Schedule();
            }
        //}
    }

}
void putwords(char const* s1){
    if(words[word_index] != 0){
        words[word_index] = s1[word_index];
        word_index ++;
    }
}
void myprintf(char* s1){
    printc(s1[-- word_index]);
}
delay(){
    int w,ww,www;
    for( w=0;w<0xFFFF;++w){
			for ( ww=0;ww<0xFF;++ww){
				for ( www=0;www<0x1;++www){
				}
			}
		}
}