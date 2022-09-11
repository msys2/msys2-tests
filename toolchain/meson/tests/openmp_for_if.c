// openmp crashes if there is a "for if" condition starting with gcc 12.1.0
// https://github.com/msys2/MINGW-packages/issues/11730#issuecomment-1138721344
// https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105745

int main(void) {
    #pragma omp parallel for if (0)
    for (int idx = 0; idx < 0; ++idx) { }
    #pragma omp for schedule(dynamic)
    for (int idx = 0; idx < 0; ++idx) { }
    return 0;
}
