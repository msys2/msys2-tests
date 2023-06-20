// llvm tries to wrongly optimize to memrchr on Windows
// https://github.com/msys2/MINGW-packages/pull/13125

#include <string.h>

int main(int argc, char **argv) {
    return strrchr("KkMm", argv[argc-1][0]) != NULL;
}
