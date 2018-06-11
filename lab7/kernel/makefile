LD=/Users/chen/toolchain/bin/i386-elf-ld
LDFLAGS=-melf_i386 -N
CC=/Users/chen/toolchain/bin/i386-elf-gcc
CCFLAGS=-march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding -g 
OBJDUMP=/Users/chen/toolchain/bin/i386-elf-objdump
OBJFLAGS=-melf_i386 -static -nostdlib --nmagic 
AS=nasm
ASFLAGS=

ROOT=..
SYSCALL=../syscall
USER=../shell
UP=../user

USER_HEADER=$(USER)/command.h 
USER_OBJ=$(USER)/command.o
STD_IO = $(SYSCALL)/stdio.h
#USER_PRO=$(UP)/user1.o $(UP)/user2.o $(UP)/user3.o $(UP)/user4.o
all: kernel.bin kernel.elf kernel.txt

kernel.bin: kernel.o   $(USER_OBJ) $(SYSCALL)/use.o $(SYSCALL)/sysc.o $(SYSCALL)/stdio.o $(SYSCALL)/interuptf.o $(SYSCALL)/time.o $(SYSCALL)/fork.o $(SYSCALL)/schedule.o#$(USER_PRO)
	$(LD) $(LDFLAGS) -Ttext 0x7d00 --oformat binary -o $@ $^
kernel.elf: kernel.o $(SYSCALL)/schedule.o $(SYSCALL)/use.o $(SYSCALL)/sysc.o  $(USER_OBJ) $(SYSCALL)/stdio.o $(SYSCALL)/interuptf.o  $(SYSCALL)/time.o $(SYSCALL)/fork.o
	$(LD) $(OBJFLAGS) -Ttext 0x7d00 -o $@ $^
kernel.txt: kernel.elf
	$(OBJDUMP) -S $^ > $@

kernel.o: kernel.c kernel.h  $(USER_HEADER) 
	$(CC) $(CCFLAGS) -c $^
$(SYSCALL)/sysc.o:
	cd $(SYSCALL)/ && make
	cd ../kernel
$(SYSCALL)/use.o:
	cd $(SYSCALL)/ && make
	cd ../kernel
$(SYSCALL)/time.o:
	cd $(SYSCALL)/ && make
	cd ../kernel
$(SYSCALL)/fork.o:
	cd $(SYSCALL)/ && make
	cd ../kernel
$(SYSCALL)/interuptf.o:
	cd $(SYSCALL)/ && make
	cd ../kernel
$(SYSCALL)/schedule.o:
	cd $(SYSCALL)/ && make
	cd ../kernel
$(SYSCALL)/stdio.o:
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
	rm *.txt -f
rebuild:
	make clean 
	make
