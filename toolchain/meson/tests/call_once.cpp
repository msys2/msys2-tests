// std::call_once from libstdc++ always segfaults on Clang 12
// https://github.com/msys2/MINGW-packages/issues/8706

#include <iostream>
#include <mutex>

int main()
{
    std::once_flag flag;
    std::call_once(flag, []{std::cout << "Once!\n";});

    return 0;
}
