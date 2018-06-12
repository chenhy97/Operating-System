LD=/Users/chen/toolchain/bin/i386-elf-ld
LDFLAGS=-melf_i386 -N
CC=/Users/chen/toolchain/bin/i386-elf-gcc
CCFLAGS=-march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding -g 
AS=nasm
ASFLAGS=


USE=../syscall

all: command.o
command.o: command.c $(USE)/stdio.h $(USE)/time.h 
	$(CC) $(CCFLAGS) -c $^

clean:
	rm *.bin -f 
	rm *.o -f  
	rm *.gch -f
rebuild:
	make clean 
	make