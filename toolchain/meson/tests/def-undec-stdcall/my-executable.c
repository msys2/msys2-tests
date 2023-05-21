#include <stdlib.h>
#include <stdio.h>

int __stdcall add_numbers(int, int);

int main(int argc, char **argv)
{
  (void) argc;
  (void) argv;

  if (add_numbers (5, 5) == 10) {
    return 0;
  }
  return 1;
}
