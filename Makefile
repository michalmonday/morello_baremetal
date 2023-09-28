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

# morello
GCC_FLAGS	= -march=morello+c64 -mabi=purecap \
			  -static \
			  -fvisibility=hidden \
			  -I$(INCLUDE_DIR) \
			  -g
			#   -nostartfiles \

LD_FLAGS=-T linker_script.ld

.PHONY: all clean
all: postcompile

start.o: 
	$(GCC) $(GCC_FLAGS) -c start.s -o start.o

$(PROG_NAME).o: $(PROG_NAME).c 
	$(GCC) $(GCC_FLAGS) -c $(PROG_NAME).c

syscalls.o: syscalls.c
	$(GCC) $(GCC_FLAGS) -c $^

$(PROG_NAME): start.o $(PROG_NAME).o syscalls.o linker_script.ld
	$(GCC) $(GCC_FLAGS) -o $@ $(PROG_NAME).o $(shell find . ! -name "start.o" ! -name "$(PROG_NAME).o" -name "*.o") $(LD_FLAGS)

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

