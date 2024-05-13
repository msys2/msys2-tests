// https://gcc.gnu.org/bugzilla/show_bug.cgi?id=115038#c1
// gcc -c -fno-omit-frame-pointer -O2 repro.cpp
struct d {
  d();
};
struct e {
  e() : c(1.0) {}
  float c;
};
struct j {
  using ad = d;
};
class k : j {
  d g;
  e h;
};
template <typename, typename, typename, typename> using i = k;
class {
  i<int, int, int, int> f;
} a;
k b;
