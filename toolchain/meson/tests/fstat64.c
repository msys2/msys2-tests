// https://github.com/mingw-w64/mingw-w64/issues/94
#include <sys/stat.h>
#include <stdlib.h>
#include <stdio.h>

int main( void )
{
#ifdef _WIN32
    struct stat64 buf;
    FILE* file;
    int result;

    file = tmpfile();
    result = fstat64(fileno(file), &buf);
    fclose(file);
    return (result == 0) ? 0 : 1;
#else
    return 0;
#endif
}
