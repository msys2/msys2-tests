// Exception handling broken when building gcc with newer grep
// https://github.com/msys2/MINGW-packages/issues/9771#issuecomment-944069197

#include <iostream>

int main () {
   try {
      throw "OK";
   } catch (const char* msg) {
     std::cerr << msg << std::endl;
   }
   return 0;
}
