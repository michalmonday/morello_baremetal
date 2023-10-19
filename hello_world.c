#include <stdio.h>
#include <stdlib.h>

void __libc_init_array(void);

void init() {
	extern char bss_start asm("BSS_START");
    extern char bss_end asm("BSS_END");
    extern char sbss_start asm("SBSS_START");
    extern char sbss_end asm("SBSS_END");

    char *bss = &bss_start;
    char *sbss = &sbss_start;

    for (; bss < &bss_end; bss++)
        *bss = 0;
    for (; sbss < &sbss_end; sbss++) 
        *sbss = 0;
}

int main(void) {
    init();
    __libc_init_array();

    setbuf(stdout, NULL);
    setbuf(stdin, NULL);

    putchar('a');
    printf("Hello World!\n");
    char *s = malloc(50);
    gets(s);

    while (1) {
    }
    return 0;
}