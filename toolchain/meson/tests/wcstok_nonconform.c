// Make sure _CRT_NON_CONFORMING_WCSTOK works as expected
// Available since https://github.com/mingw-w64/mingw-w64/commit/bafccb49a0a6b4676f748bb415aabe27212d12d7
#define _CRT_NON_CONFORMING_WCSTOK
#include <wchar.h>

int main(void)
{
    wchar_t s[] = L"a,b,c";
    wchar_t *p;
    int count = 0;

#ifdef _WIN32
    for(p = wcstok(s, L","); p; p = wcstok(NULL, L","))
        count++;
#else
    wchar_t *ctx;
    for(p = wcstok(s, L",", &ctx); p; p = wcstok(NULL, L",", &ctx))
        count++;
#endif

    return (count == 3) ? 0 : 1;
}
