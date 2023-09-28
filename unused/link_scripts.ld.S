OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH("aarch64")
ENTRY(main)

MEMORY {
  RAM (rwx): ORIGIN = 0xE0000000, LENGTH = 0xE0000000 + 0x200000
}

SECTIONS
{
  . = 0xE0000000;

  ro . : {
    */helloworld.o(.text)
    *(.text*)
    *(.rodata*)
  } >RAM

  .data : {
    *(.data*)
  } >RAM
}

