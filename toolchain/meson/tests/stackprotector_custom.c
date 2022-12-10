// This is just a small test that checks if __stack_chk_fail is called
// if there is a buffer overflow with -fstack-protector-strong enabled

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

void __stack_chk_fail(void)
{
    exit(0);
}

void get_input(char *data)
{
    strcpy(data, "01234567890123456789");
}

int main(void)
{
    char buffer[8];
    get_input(buffer);
    return 1;
}
