// https://github.com/msys2/MINGW-packages/issues/8301

#include <stdio.h>
#include <stdint.h>

int main(void) {
    int64_t node_base_id = INT64_C(1000000000000);
    printf("%lld\n", node_base_id);
    return 0;
}
