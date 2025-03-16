#include <assert.h>
#include <stdio.h>
#include <windows.h>

__declspec(dllexport) int main_f(void) { return 42; }

int main(void) {
  HMODULE lib = LoadLibraryA("lib.dll");
  assert(lib);
  printf("MAIN: lib.dll loaded\n");
  FARPROC func = GetProcAddress(lib, "lib_f");
  assert(func);
  printf("MAIN: lib_f retrieved\n");
  int lib_return = func();
  printf("MAIN: lib_f called\n");
  assert(lib_return == main_f());
  printf("MAIN: OK\n");

  return 0;
}