// https://github.com/msys2/MINGW-packages/issues/24925
#include <stdio.h>
#include <string.h>

int main(void)
{
    char buffer[100];
    const char* expected = "------[Hello]-----\n";
    snprintf(buffer, sizeof(buffer), "------[%ls]-----\n", L"Hello");
    return (strcmp(buffer, expected) != 0);
}
