LD=/Users/chen/toolchain/bin/i386-elf-ld
LDFLAGS=-melf_i386 -N
CC=/Users/chen/toolchain/bin/i386-elf-gcc
CCFLAGS=-march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding
AS=nasm
ASFLAGS=

SYSCALL = syscall 
SHEL = shell
LOADER = loader
KERNEL = kernel
USER = user
USER_PRO=$(USER)/user1.bin $(USER)/user2.bin $(USER)/user3.bin $(USER)/user4.bin $(USER)/infoP.bin

all: $(KERNEL)/kernel.bin $(LOADER)/loader.bin $(USER_PRO) build cleangch

$(KERNEL)/kernel.bin: 
	cd $(KERNEL)/ && make
	cd $(ROOT)/
$(SYSCALL)/sysc.o use.o: 
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

build: $(LOADER)/loader.bin $(KERNEL)/kernel.bin
	dd if=$(LOADER)/loader.bin of=S.img conv=notrunc;sync
	dd if=$(KERNEL)/kernel.bin of=S.img bs=512  conv=notrunc seek=1;sync
	dd if=$(USER)/infoP.bin of=S.img bs=512 count=2 conv=notrunc seek=20;sync
	dd if=$(USER)/user1.bin of=S.img bs=512 count=2 conv=notrunc seek=22;sync 
	dd if=$(USER)/user2.bin of=S.img bs=512 count=2 conv=notrunc seek=24;sync
	dd if=$(USER)/user3.bin of=S.img bs=512 count=2 conv=notrunc seek=26;sync
	dd if=$(USER)/user4.bin of=S.img bs=512 count=2 conv=notrunc seek=28;sync
clean:
	find . -name "*.bin" -type f -delete
	find . -name "*.o" -type f -delete
	find . -name "*.gch" -type f -delete
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


