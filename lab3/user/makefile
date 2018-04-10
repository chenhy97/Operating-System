LD=/Users/chen/toolchain/bin/i386-elf-ld
LDFLAGS=-melf_i386 -N
CC=/Users/chen/toolchain/bin/i386-elf-gcc
CCFLAGS=-march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding
AS=nasm
ASFLAGS=

SYSCALL=../syscall
all:	user1.bin user2.bin user3.bin user4.bin infoP.bin

user1.bin: user1.o  $(SYSCALL)/sysc.o 
	$(LD) $(LDFLAGS) -Ttext 0xC000 --oformat binary -o $@ $^
user2.bin: user2.o  $(SYSCALL)/sysc.o 
	$(LD) $(LDFLAGS) -Ttext 0xC000 --oformat binary -o $@ $^
user3.bin: user3.o  $(SYSCALL)/sysc.o 
	$(LD) $(LDFLAGS) -Ttext 0xC000 --oformat binary -o $@ $^
user4.bin: user4.o  $(SYSCALL)/sysc.o 
	$(LD) $(LDFLAGS) -Ttext 0xC000 --oformat binary -o $@ $^
infoP.bin: infoP.o  $(SYSCALL)/sysc.o 
	$(LD) $(LDFLAGS) -Ttext 0xb100 --oformat binary -o $@ $^

user1.o: user1.asm
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@

user2.o: user2.asm
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@

user3.o: user3.asm
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@

user4.o: user4.asm
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@
infoP.o: infoP.asm
	$(AS) $(ASFLAGS) -f elf32 $^ -o $@
clean:
	rm *.bin -f 
	rm *.o -f  
	rm *.gch -f
rebuild:
	make clean 
	make