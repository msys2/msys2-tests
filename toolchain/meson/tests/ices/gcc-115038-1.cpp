// https://gcc.gnu.org/bugzilla/show_bug.cgi?id=115038#c0
// gcc -c -fno-omit-frame-pointer -O2 repro.cpp
template <typename a> void b(a, a);
template <typename a> void c(a, a, float);
float d;
void e() {
  float f;
  c(f, f, d);
  b(0.0f, f);
}
