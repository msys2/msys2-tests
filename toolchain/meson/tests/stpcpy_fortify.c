// In case GCC sees a stpcpy() despite that not being available on Windows
// it will transform strcpy()+strlen() to it. If in addition _FORTIFY_SOURCE is set
// then it will convert that to __stpcpy_chk(), which needs to be provided by something
// or we'll get "undefined reference to `__stpcpy_chk'"
// https://github.com/msys2/MINGW-packages/issues/5803#issuecomment-1278895379

#include <string.h>

#ifndef __CYGWIN__
char *stpcpy(char *_Dest, const char *_Source);
char *stpcpy(char *_Dest, const char *_Source)
{
    while ((*_Dest++ = *_Source++) != '\0');
    return --_Dest;
}
#endif

int func(const char* src) {
    char name[1000];
    strcpy(name, src);
    return strlen(name);
}

int main(void) {
    return func("foo") == 4;
}
