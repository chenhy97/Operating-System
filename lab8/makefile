LD=/Users/chen/toolchain/bin/i386-elf-ld
LDFLAGS=-melf_i386 -N
CC=/Users/chen/toolchain/bin/i386-elf-gcc
CCFLAGS=-march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding -g
AS=nasm
ASFLAGS=

SYSCALL = syscall 
SHEL = shell
LOADER = loader
KERNEL = kernel
USER = user
USER_PRO=$(USER)/user1.bin $(USER)/user2.bin $(USER)/user3.bin $(USER)/user4.bin $(USER)/test.bin#$(USER)/infoP.bin

all: $(KERNEL)/kernel.bin $(LOADER)/loader.bin $(USER_PRO) build cleangch

$(KERNEL)/kernel.bin: 
	cd $(KERNEL)/ && make
	cd $(ROOT)/
$(SYSCALL)/sysc.o use.o stdio.o interuptf.o: 
	cd $(SYSCALL)/ && make
	cd $(ROOT)/
$(SHEL)/command.o: 
	cd $(SHEL)/ && make
	cd $(ROOT)/
$(LOADER)/loader.bin: 
	cd $(LOADER) && make
	cd $(ROOT)/
$(USER)/user1.bin:
	cd $(USER)/ && make
	cd $(ROOT)/
$(USER)/user2.bin:
	cd $(USER)/ && make
	cd $(ROOT)/
$(USER)/user3.bin:
	cd $(USER)/ && make
	cd $(ROOT)/
$(USER)/user4.bin:
	cd $(USER)/ && make
	cd $(ROOT)/
$(USER)/test.bin:
	cd $(USER)/ && make
	cd $(ROOT)/

build: $(LOADER)/loader.bin $(KERNEL)/kernel.bin
	dd if=$(LOADER)/loader.bin of=S.img conv=notrunc;sync
	dd if=$(KERNEL)/kernel.bin of=S.img bs=512 count=90 conv=notrunc seek=1;sync
	#dd if=$(USER)/user1.bin of=S.img bs=512 count=25 conv=notrunc seek=94;sync 
	dd if=$(USER)/user2.bin of=S.img bs=512 count=25 conv=notrunc seek=124;sync
	dd if=$(USER)/user4.bin of=S.img bs=512 count=25 conv=notrunc seek=184;sync
	dd if=$(USER)/test.bin of=S.img bs=512 count=25 conv=notrunc seek=214;sync
	dd if=$(USER)/testfork.bin of=S.img bs=512 count=30 conv=notrunc seek=234;sync
	dd if=$(USER)/testsem.bin of=S.img bs=512 count=30 conv=notrunc seek=264;sync
	dd if=$(USER)/fruit.bin of=S.img bs=512 count=30 conv=notrunc seek=294;sync
clean:
	find . -name "*.bin" -type f -delete
	find . -name "*.o" -type f -delete
	find . -name "*.gch" -type f -delete
	find . -name "*.elf" -type f -delete
	find . -name "*.txt" -type f -delete
run:
	bochs -q
rebuild:
	make clean 
	clear
	make
auto:
	make rebuild
	make run
cleangch:
	find . -name "*.gch" -type f -delete


