// some code defines snprintf before importing stdio.h
// https://sourceforge.net/p/mingw-w64/mailman/mingw-w64-public/thread/CAE6_%2BUeY-4bQ8BhHN3YvGOFRAQMbM9j79YG0kneRN3mxUzCYPg%40mail.gmail.com/#msg37282988

#define __USE_MINGW_ANSI_STDIO 1
#define snprintf _snprintf
#include <stdio.h>
int main (void) {
    return 0;
}
