PROG_NAME 	= hello_world

INCLUDE_DIR = ../include
ALGORITHMS_DIR = algorithms

# TOOLCHAIN = riscv64-unknown-elf
TOOLCHAIN = aarch64-none-elf

GCC = $(TOOLCHAIN)-gcc
OBDUMP = $(TOOLCHAIN)-objdump
OBJCOPY = $(TOOLCHAIN)-objcopy

# GCC_FLAGS	= -march=rv64g -mabi=lp64d -static \
# 			  -fvisibility=hidden \
# 			  -nostartfiles \
# 			  -mcmodel=medany \
# 			  -I$(INCLUDE_DIR) \
# 			  -I$(ALGORITHMS_DIR)

LIB = /home/michal/llvm-project-releases/aarch64-none-elf+morello+c64+purecap/lib


REBUILT_TOOLCHAIN = /home/michal/rebuild-newlib

# vshcmd: >   -march=morello+c64 -mabi=purecap -nostartfiles -L rebuild-newlib/newlib-install/aarch64-none-elf/lib/purecap/c64/ \
# vshcmd: >   -Wl,arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf/lib/gcc/aarch64-none-elf/10.1.0/purecap/c64/crti.o,arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf/lib/gcc/aarch64-none-elf/10.1.0/purecap/c64/crtbegin.o,./rebuild-newlib/newlib-install/aarch64-none-elf/lib/purecap/c64/morello-el2-crt0.o,./rebuild-newlib/newlib-install/aarch64-none-elf/lib/purecap/c64/cpu-init/morello-init-el2.o,--start-group,-lc,-lgloss-morello-el2,--end-group,arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf/lib/gcc/aarch64-none-elf/10.1.0/purecap/c64/crtend.o,arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf/lib/gcc/aarch64-none-elf/10.1.0/purecap/c64/crtn.o test.c -o test-direct-alt

# morello
GCC_FLAGS	= -march=morello+c64 -mabi=purecap \
			  -static \
			  -fvisibility=hidden \
			  -I$(INCLUDE_DIR) \
			  -g \
			  -L /home/michal/rebuild-newlib/newlib-install/aarch64-none-elf/lib/purecap/c64/ \
			  -specs=/home/michal/arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf_modified/aarch64-none-elf/lib/morello-board-el2.specs \
			  -D__MORELLO_EL2__ \
			  -D__NOSEMIHOSTING__ 

			#   -L /home/michal/rebuild-newlib/newlib-install/aarch64-none-elf/lib/purecap/c64/ \
			#   -Wl,/home/michal/arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf_modified/lib/gcc/aarch64-none-elf/10.1.0/purecap/c64/crti.o,/home/michal/arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf_modified/lib/gcc/aarch64-none-elf/10.1.0/purecap/c64/crtbegin.o,/home/michal/rebuild-newlib/newlib-install/aarch64-none-elf/lib/purecap/c64/morello-el2-crt0.o,/home/michal/rebuild-newlib/newlib-install/aarch64-none-elf/lib/purecap/c64/cpu-init/morello-init-el2.o,--start-group,-lc,-lgloss-morello-el2,--end-group,/home/michal/arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf_modified/lib/gcc/aarch64-none-elf/10.1.0/purecap/c64/crtend.o,/home/michal/arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf_modified/lib/gcc/aarch64-none-elf/10.1.0/purecap/c64/crtn.o \
			#   -D__MORELLO_EL2__ \
			#   -D__NOSEMIHOSTING__ 

			#   -D__MORELLO_EL2__ \
			#   -D__NOSEMIHOSTING__ \
			#   -specs=/home/michal/arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf/aarch64-none-elf/lib/purecap/c64/aem-validation.specs
			#   -specs=/home/michal/arm-gnu-toolchain-10.1.morello-alp2-x86_64-aarch64-none-elf/aarch64-none-elf/lib/purecap/c64/rdimon.specs
			#   -nostartfiles

LD_FLAGS=-T linker_script.ld
# LD_FLAGS=


.PHONY: all clean
all: postcompile

start.o: 
	$(GCC) $(GCC_FLAGS) -c start.s -o start.o

$(PROG_NAME).o: $(PROG_NAME).c 
	$(GCC) $(GCC_FLAGS) -c $(PROG_NAME).c

syscalls.o: syscalls.c
	$(GCC) $(GCC_FLAGS) -c $^

# $(PROG_NAME): start.o $(PROG_NAME).o syscalls.o linker_script.ld
	# $(GCC) $(GCC_FLAGS) -o $@ $(PROG_NAME).o $(shell find . ! -name "start.o" ! -name "$(PROG_NAME).o" -name "*.o") $(LD_FLAGS)

$(PROG_NAME): start.o $(PROG_NAME).o linker_script.ld
	$(GCC) $(GCC_FLAGS) -o $@ $(PROG_NAME).o $(shell find . ! -name "syscalls.o" ! -name "start.o" ! -name "$(PROG_NAME).o" -name "*.o") $(LD_FLAGS)

postcompile: $(PROG_NAME)
	$(OBDUMP) -sSD $(PROG_NAME) > $(PROG_NAME).dump
	$(OBJCOPY) -O binary $(PROG_NAME) $(PROG_NAME).bin
	cp $(PROG_NAME) /mnt/hgfs/shared
	cp $(PROG_NAME).bin /mnt/hgfs/shared
	cp $(PROG_NAME).dump /mnt/hgfs/shared
	rm *.o
	echo "Done!"

clean:
	rm *.o $(PROG_NAME) $(PROG_NAME).dump $(PROG_NAME).bin

