LD=/Users/chen/toolchain/bin/i386-elf-ld
LDFLAGS=-melf_i386 -N
CC=/Users/chen/toolchain/bin/i386-elf-gcc
CCFLAGS=-march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding
AS=nasm
ASFLAGS=

ROOT=..
SYSCALL=../syscall
USER=../shell
UP=../user

USER_HEADER=$(USER)/command.h 
USER_OBJ=$(USER)/command.o
#USER_PRO=$(UP)/user1.o $(UP)/user2.o $(UP)/user3.o $(UP)/user4.o
all: kernel.bin

kernel.bin: kernel.o $(SYSCALL)/use.o $(SYSCALL)/sysc.o $(USER_OBJ) #$(USER_PRO)
	$(LD) $(LDFLAGS) -Ttext 0x7e00 --oformat binary -o $@ $^
kernel.o: kernel.c kernel.h   $(USER_HEADER)
	$(CC) $(CCFLAGS) -c $^
$(SYSCALL)/sysc.o:
	cd $(SYSCALL)/ && make
	cd ../kernel
$(SYSCALL)/use.o:
	cd $(SYSCALL)/ && make
	cd ../kernel
$(USER)/command.o:
	cd $(USER)/ && make
	cd ../kernel
$(UP)/user1.o:
	cd $(UP)/ && make
	cd ../kernel
$(UP)/user2.o:
	cd $(UP)/ && make
	cd ../kernel
$(UP)/user3.o:
	cd $(UP)/ && make
	cd ../kernel
$(UP)/user4.o:
	cd $(UP)/ && make
	cd ../kernel
clean:
	rm *.bin -f 
	rm *.o -f  
	rm *.gch -f
rebuild:
	make clean 
	make