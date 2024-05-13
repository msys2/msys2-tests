// https://gcc.gnu.org/bugzilla/show_bug.cgi?id=115038#c5
// gcc -c -O2 repro.c -> internal compiler error: in seh_cfa_offset
// gcc -c -g3 -O2 -gdwarf-2 repro.c -> internal compiler error: in 
void a() {
    __builtin_unwind_init();
}
