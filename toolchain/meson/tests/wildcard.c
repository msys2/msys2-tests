#include <string.h>

#ifdef __CYGWIN__
    #undef DO_WILDCARD
    #define DO_WILDCARD 0
#else
    #define DO_WILDCARD_DEFAULT 0
    #ifndef DO_WILDCARD
        #define DO_WILDCARD DO_WILDCARD_DEFAULT
    #else
        int _dowildcard = DO_WILDCARD;
    #endif
#endif

int main(int argc, char *argv[]) {
    // This gets called with "tests/wildc*_on.exe"
    if (DO_WILDCARD) {
        return !(argc >= 2 && strcmp(argv[1], "tests/wildcard_on.exe") == 0);
    } else {
        return !(argc >= 2 && strcmp(argv[1], "tests/wildc*_on.exe") == 0);
    }
}
