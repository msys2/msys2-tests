// https://sourceforge.net/p/mingw-w64/mailman/mingw-w64-public/thread/CAE6_%2BUduYv2a_-PVLHuuj4wWa%3DrMR8Dq95Nht8rxWoBZ3EtqHQ%40mail.gmail.com/#msg37268077

#ifdef _UCRT
#define _GLIBCXX_HAVE_QUICK_EXIT 1
#endif
#include <process.h>
#include <cstdlib>
int main()
{
#ifdef _UCRT
  ::std::quick_exit(0);
#endif
  return 0;
}
