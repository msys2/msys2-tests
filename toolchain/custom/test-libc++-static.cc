#include <string>
#include <iostream>

int main() {
  auto test = new std::string("test");
  std::cout << *test << std::endl;
  delete test;
  return 0;
}
