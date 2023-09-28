# Script based on instructions from:
# https://git.morello-project.org/morello/docs/-/blob/morello/release-1.4/standalone-baremetal-readme.rst 

# First argument = program name (must match basename of .c file)

PROGRAM_NAME=$1
PWD=`pwd`
MORELLO_WORKSPACE=/home/michal/morello_board/morello_workspace
TOOLCHAIN=/home/michal/morello_board/morello_workspace/llvm-project-releases
OUTPUT=/home/michal/morello_board/standalone_output
PROGRAM_PATH=$PWD #/home/michal/morello_board/standalone_build/helloworld



################################################
# COMPILE PROGRAM

$TOOLCHAIN/bin/clang -target aarch64-none-elf -c $PROGRAM_NAME.c -o $PROGRAM_NAME.o -O3 -g
$TOOLCHAIN/bin/ld.lld -o $PROGRAM_NAME.elf -T link_scripts.ld.S $PROGRAM_NAME.o -s
$TOOLCHAIN/bin/llvm-objcopy -O binary $PROGRAM_NAME.elf $PROGRAM_NAME



################################################
# OUTPUT OBJDUMP (disassembly)

$TOOLCHAIN/bin/llvm-objdump -sSD $PROGRAM_NAME.elf > $PROGRAM_NAME.objdump



################################################
# PACKAGE COMPILED PROGRAM

cd $MORELLO_WORKSPACE
make -C "bsp/arm-tf" PLAT=morello TARGET_PLATFORM=soc clean
MBEDTLS_DIR="$MORELLO_WORKSPACE/bsp/deps/mbedtls" \
CROSS_COMPILE="$MORELLO_WORKSPACE/tools/clang/bin/llvm-" \
make -C "bsp/arm-tf" \
CC="$MORELLO_WORKSPACE/tools/clang/bin/clang" \
LD="$MORELLO_WORKSPACE/tools/clang/bin/ld.lld" \
PLAT=morello ARCH=aarch64 TARGET_PLATFORM=soc ENABLE_MORELLO_CAP=1 \
E=0 TRUSTED_BOARD_BOOT=1 GENERATE_COT=1 ARM_ROTPK_LOCATION="devel_rsa" \
ROT_KEY="plat/arm/board/common/rotpk/arm_rotprivk_rsa.pem" \
BL33=$PROGRAM_PATH/$PROGRAM_NAME \
all fip

cp $MORELLO_WORKSPACE/bsp/arm-tf/build/morello/release/*.bin $OUTPUT/

cd $PWD
