LD=/Users/chen/toolchain/bin/i386-elf-ld
LDFLAGS=-melf_i386 -N
CC=/Users/chen/toolchain/bin/i386-elf-gcc
CCFLAGS=-march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding -g 
OBJDUMP=/Users/chen/toolchain/bin/i386-elf-objdump
OBJFLAGS=-melf_i386 -static -nostdlib --nmagic 
AS=nasm
ASFLAGS=

SYSCALL=../syscall
all:	user1.bin user2.bin user3.bin user4.bin test.bin testfork.bin testfork.elf test.elf testfork.txt test.txt user1.elf user1.txt testsem.bin testsem.elf testsem.txt fruit.bin fruit.elf fruit.txt#infoP.bin

user1.bin: user1.o  $(SYSCALL)/sysc.o  $(SYSCALL)/interuptf.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(LDFLAGS) -Ttext 0x100 --oformat binary -o $@ $^
user2.bin: user2.o  $(SYSCALL)/sysc.o $(SYSCALL)/interuptf.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(LDFLAGS) -Ttext 0x100 --oformat binary -o $@ $^
user3.bin: user3.o  $(SYSCALL)/sysc.o $(SYSCALL)/interuptf.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(LDFLAGS) -Ttext 0x100 --oformat binary -o $@ $^
user4.bin: user4.o  $(SYSCALL)/sysc.o $(SYSCALL)/interuptf.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(LDFLAGS) -Ttext 0x100 --oformat binary -o $@ $^
test.bin: test.o  $(SYSCALL)/sysc.o $(SYSCALL)/interuptf.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(LDFLAGS) -Ttext 0x100 --oformat binary -o $@ $^
testfork.bin:testfork.o $(SYSCALL)/sysc.o  $(SYSCALL)/interuptf.o $(SYSCALL)/stdio.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(LDFLAGS) -Ttext 0x100 --oformat binary -o $@ $^
testsem.bin:testsem.o $(SYSCALL)/sysc.o  $(SYSCALL)/interuptf.o $(SYSCALL)/stdio.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(LDFLAGS) -Ttext 0x100 --oformat binary -o $@ $^
fruit.bin:fruit.o $(SYSCALL)/sysc.o  $(SYSCALL)/interuptf.o $(SYSCALL)/stdio.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(LDFLAGS) -Ttext 0x100 --oformat binary -o $@ $^

testsem.elf:testsem.o  $(SYSCALL)/sysc.o  $(SYSCALL)/interuptf.o $(SYSCALL)/stdio.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(OBJFLAGS) -Ttext 0x100 -o $@ $^
testfork.elf:testfork.o  $(SYSCALL)/sysc.o  $(SYSCALL)/interuptf.o $(SYSCALL)/stdio.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(OBJFLAGS) -Ttext 0x100 -o $@ $^
fruit.elf:fruit.o  $(SYSCALL)/sysc.o  $(SYSCALL)/interuptf.o $(SYSCALL)/stdio.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(OBJFLAGS) -Ttext 0x100 -o $@ $^
test.elf: test.o  $(SYSCALL)/sysc.o $(SYSCALL)/interuptf.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(OBJFLAGS) -Ttext 0x100 -o $@ $^
test.txt: test.elf
	$(OBJDUMP) -S $^ > $@
testfork.txt: testfork.elf
	$(OBJDUMP) -S $^ > $@
testsem.txt: testsem.elf
	$(OBJDUMP) -S $^ > $@
fruit.txt: fruit.elf
	$(OBJDUMP) -S $^ > $@
user1.elf: user1.o  $(SYSCALL)/sysc.o $(SYSCALL)/interuptf.o $(SYSCALL)/schedule.o $(SYSCALL)/fork.o 
	$(LD) $(OBJFLAGS) -Ttext 0x100 -o $@ $^
user1.txt: user1.elf
	$(OBJDUMP) -S $^ > $@
#infoP.bin: infoP.o  $(SYSCALL)/sysc.o 
#	$(LD) $(LDFLAGS) -Ttext 0xb100 --oformat binary -o $@ $^

user1.o: user1.asm
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@

user2.o: user2.asm
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@

user3.o: user3.asm
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@

user4.o: user4.asm
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@
#infoP.o: infoP.asm
#	$(AS) $(ASFLAGS) -f elf32 $^ -o $@
test.o: test.asm
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@

testfork.o:testfork.c testfork.h  $(SYSCALL)/fork.h 
	$(CC) $(CCFLAGS) -c $^
testsem.o:testsem.c testsem.h  $(SYSCALL)/fork.h 
	$(CC) $(CCFLAGS) -c $^
fruit.o:fruit.c  $(SYSCALL)/fork.h 
	$(CC) $(CCFLAGS) -c $^
clean:
	rm *.bin -f 
	rm *.o -f  
	rm *.gch -f
rebuild:
	make clean 
	make