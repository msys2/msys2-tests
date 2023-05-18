# https://github.com/msys2/MINGW-packages/pull/17163
# https://sourceforge.net/p/mingw-w64/mailman/message/37839853/
# https://sourceware.org/bugzilla/show_bug.cgi?id=30421
# In case the exported symbols are forced undecorated via a .def file
# then binutils also wrongly added them undecortaed to the import library.

lib = shared_library('my-shared-lib',
                     'my-shared-lib.c',
                     vs_module_defs: 'my-shared-lib.def')

exec = executable('my-executable',
                  'my-executable.c',
                  link_with: [lib])

test('def_undec_stdcall', exec)
