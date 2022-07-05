// In some cases pow() would not be as precise as it could be
// https://github.com/msys2/MINGW-packages/issues/11733

#include <math.h>
#include <inttypes.h>

typedef union {double d; uint64_t i;} test;

int
main(void)
{
    test tmp1;
    test tmp2;
    tmp1.d = pow(10, -9);
    tmp2.d = 1e-9;
    return (tmp1.i == tmp2.i) ? 0 : 1;
}
