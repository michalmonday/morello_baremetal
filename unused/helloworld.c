#include <stdio.h>

#define plat_arm_boot_uart_base 0x2a400000

volatile char * ptr = (volatile char*) plat_arm_boot_uart_base;

int main()
{
  *ptr='a';
  *ptr='b';
  *ptr='c';
  *ptr='!';
  while (1);
  return 0;
}
