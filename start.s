.global _start

_start:
    adrp    c1, STACK_TOP                
    add     c1, c1, :lo12:STACK_TOP      
    mov     csp, c1

/*
    LDR     r0, =STACK_TOP
    MOV     sp, r0;
*/
    b       main;
    b       park;

/*
    csrr    t0, mhartid             # read current hart id
    bnez    t0, park                # single core only, park hart != 0
    la      sp, STACK_TOP           # setup stack
    j       main                    # jump to c
    j       park
*/

park:
    wfi
    /* j       park */
    b       park
