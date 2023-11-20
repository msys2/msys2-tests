// https://github.com/msys2/MINGW-packages/pull/18983#issuecomment-1791570172

#include <stdio.h>
#include <stdint.h>
#include <libintl.h>

int main(void)
{
#ifdef _WIN32
    char buf[1024] = "(failure)";
    int len = libintl_snprintf(buf, 1024, "hello %llu %I64u 0:%d\n", (uint64_t)123, (uint64_t)123, 0);

    printf("%d, '%s'\n", len, buf);

    return len < 0 ? 1 : 0;
#else
    return 0;
#endif
}
