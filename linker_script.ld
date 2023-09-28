OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH("aarch64")
ENTRY( _start )
SECTIONS
{
  /* RAM (rwx): ORIGIN = 0xE0000000, LENGTH = 0xE0000000 + 0x200000 */
  START_ADDRESS = 0xE0000000;
  STACK_TOP = 0xE01ffc00; /* Memory size is 0x200000 */
                
  
  /* start addresss */
  . = START_ADDRESS;

  /* text */
  .text : { 
    *(.text) 
    *(.text*)
    *(.rodata)
    *(.rodata*)
  } 

  /* No idea if the following 3 sections (__cap_relocs, .captable, .htif) are needed
     or declared properly. The only reason why these were put here because I've seen 
     such sections in another program compiled with llvm ("bbl" for cheribsd). */
  .__cap_relocs : {
    *(.__cap_relocs)
    *(.__cap_relocs*)
  }

  .captable : {
    *(.captable)
    *(.captable*)
  }

  .htif : {
    *(.htif)
    *(.htif*)
  }

  /* // the following sections were found on internet, but I don't know if they are needed

    fini : {
        KEEP (*(SORT_NONE(.fini)))
    } 

    .preinit_array : ALIGN(8) {
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP (*(.preinit_array))
        PROVIDE_HIDDEN (__preinit_array_end = .);
    } 

    .init_array : ALIGN(8) {
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP (*(SORT_BY_INIT_PRIORITY(.init_array.*) SORT_BY_INIT_PRIORITY(.ctors.*)))
        KEEP (*(.init_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .ctors))
        PROVIDE_HIDDEN (__init_array_end = .);
        PROVIDE_HIDDEN ( metal_constructors_start = .);
        KEEP (*(SORT_BY_INIT_PRIORITY(.metal.init_array.*)));
        KEEP (*(.metal.init_array));
        PROVIDE_HIDDEN ( metal_constructors_end = .);
    } 

    .fini_array : ALIGN(8) {
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP (*(SORT_BY_INIT_PRIORITY(.fini_array.*) SORT_BY_INIT_PRIORITY(.dtors.*)))
        KEEP (*(.fini_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .dtors))
        PROVIDE_HIDDEN (__fini_array_end = .);
        PROVIDE_HIDDEN ( metal_destructors_start = .);
        KEEP (*(SORT_BY_INIT_PRIORITY(.metal.fini_array.*)));
        KEEP (*(.metal.fini_array));
        PROVIDE_HIDDEN ( metal_destructors_end = .);
    } 

 

    .ctors : {
        KEEP (*crtbegin.o(.ctors))
        KEEP (*crtbegin?.o(.ctors))
        KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
        KEEP (*(SORT(.ctors.*)))
        KEEP (*(.ctors))
        KEEP (*(.metal.ctors .metal.ctors.*))
    } 

    .dtors : {
        KEEP (*crtbegin.o(.dtors))
        KEEP (*crtbegin?.o(.dtors))
        KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
        KEEP (*(SORT(.dtors.*)))
        KEEP (*(.dtors))
        KEEP (*(.metal.dtors .metal.dtors.*))
    }  */


  
  /* data */
  .gnu_build_id : { *(.note.gnu.build-id) }
  .data : ALIGN(8) { 
    *(.data) 
    *(.data*)
    *(.gnu.linkonce.d.*)
    . = ALIGN(8);
    /* PROVIDE( __global_pointer$ = . + 0x800 ); */
    *(.sdata .sdata.* .sdata2.*)
    *(.gnu.linkonce.s.*)
  }

  .sbss : ALIGN(8) {
    SBSS_START = .;
     *(.sbss) 
     *(.sbss*)
     *(.scommon)
    . = ALIGN(8);
    SBSS_END = .;
  } /* static local variables */
  .bss : ALIGN(8) { 
    BSS_START = .;
    __bss_start__ = BSS_START;
    *(.bss) 
    *(.bss*)
    *(COMMON)
    . = ALIGN(8);
    BSS_END = .;
    __bss_end__ = BSS_END;
  } /* global variables */

  .debug : ALIGN(8) { 
    *(.debug)
  }

  HEAP_START = ALIGN(8);
  
  _end = .;
  __end__ = _end;
}
