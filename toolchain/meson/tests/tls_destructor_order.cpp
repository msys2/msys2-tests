// This was broken with old mingw-w64 and resulted in msvcrt doxygen crashing
// https://github.com/msys2/MINGW-packages/issues/32325

#include <cstdlib>

static bool tls_destroyed = false;

struct Global {
    ~Global() {
        if (!tls_destroyed) {
            std::abort();
        }
    }
};
static Global global;

struct ThreadLocal {
    ~ThreadLocal() { tls_destroyed = true; }
};

int main(void) {
    static thread_local ThreadLocal local;
    (void)local;
    return 0;
}
