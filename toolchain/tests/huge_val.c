// _HUGE, HUGE missing with ucrt
// https://github.com/msys2/MINGW-packages/issues/8375

#include <math.h>
#include <stdio.h>

int main(void) {
#ifdef _WIN32
  char buffer [100];
  snprintf(buffer, 100, "%f %f", _HUGE, HUGE_VAL);
#endif
  return 0;
}
