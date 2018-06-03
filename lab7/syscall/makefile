LD=/Users/chen/toolchain/bin/i386-elf-ld
LDFLAGS=-melf_i386 -N
CC=/Users/chen/toolchain/bin/i386-elf-gcc
CCFLAGS=-march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding -g 
AS=nasm
ASFLAGS=


all : sysc.o use.o interuptf.o stdio.o schedule.o time.o fork.o


sysc.o: sysc.asm 
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@
use.o : use.c use.h
	$(CC) $(CCFLAGS) -c $^
interuptf.o : interuptf.c stdio.h use.h
	$(CC) $(CCFLAGS) -c $^
fork.o : fork.c fork.h schedule.h
	$(CC) $(CCFLAGS) -c $^
time.o : time.c time.h
	$(CC) $(CCFLAGS) -c $^
schedule.o : schedule.c schedule.h
	$(CC) $(CCFLAGS) -c $^
stdio.o : stdio.c stdio.h
	$(CC) $(CCFLAGS) -c $^
clean:
	rm *.bin -f 
	rm *.o -f 
	rm *.gch -f
run:
	bochs -q
rebuild:
	make clean 
	make