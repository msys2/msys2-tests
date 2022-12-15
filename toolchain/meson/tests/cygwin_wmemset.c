// https://cygwin.com/pipermail/cygwin/2022-December/252699.html
// Calling wmemset() resulted in garbage in the destination buffer

#include <wchar.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    char dest[50] = { 0 };
    wchar_t src[] = L"example";
    wmemset(src, L'E', 1);
    wcstombs(dest, src, 7);
    return strcmp(dest, "Example");
}
