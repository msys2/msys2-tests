// In case libc++ isn't built with __USE_MINGW_ANSI_STDIO handling of long double is broken
// https://github.com/msys2/MINGW-packages/pull/21796
// https://github.com/msys2/MINGW-packages/issues/21768
// https://github.com/msys2/MINGW-packages/issues/17795

#include <sstream>
#include <string>
#include <iostream>

int main() {
    long double number = 3.14159265358979323846L;
    std::stringstream ss;
    ss << number;
    std::string str = ss.str();
    return !(str.find("3.1415") == 0);
}
