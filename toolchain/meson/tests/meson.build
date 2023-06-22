test('huge_val', executable('huge_val', 'huge_val.c'))
test('snprintf_redef', executable('snprintf_redef', 'snprintf_redef.c'))
test('quick_exit', executable('quick_exit', 'quick_exit.cpp'))
test('exception_handling', executable('exception_handling', 'exception_handling.cpp'))
test('printf_format', executable('printf_format', 'printf_format.c'))
if not get_option('cross')
    test('pch', executable('pch', 'pch.cpp', cpp_pch : 'pch/pch.hpp'))
endif

openmp = dependency('openmp')
env = environment()
env.set('OMP_NUM_THREADS', '1')
test('openmp_for_if', executable('openmp_for_if', 'openmp_for_if.c', dependencies : [openmp]), env : env)
test('pow', executable('pow', 'pow.c', c_args: ['-fno-builtin', '-fno-strict-aliasing']))

windres_res = import('windows').compile_resources('windres.rc')
windres = executable('windres', 'windres.c', windres_res)
test('windres', windres)

if not get_option('cross')
    test('call_once', executable('call_once', 'call_once.cpp'))
endif
test('undef_memrchr', executable('undef_memrchr', 'undef_memrchr.c', c_args: ['-O3']))

test('stpcpy_fortify', executable('stpcpy_fortify', 'stpcpy_fortify.c', c_args: ['-O3', '-D_FORTIFY_SOURCE=2']))

test('stackprotector_custom', executable('stackprotector_custom', 'stackprotector_custom.c', c_args: ['-O0', '-fstack-protector-strong']))

test('cygwin_wmemset', executable('cygwin_wmemset', 'cygwin_wmemset.c'))

test('posix_sem', executable('posix_sem', 'posix_sem.c', dependencies: [dependency('threads')]))

test('posix_sem_named', executable('posix_sem_named', 'posix_sem_named.c', dependencies: [dependency('threads')]))

test('posix_shm', executable('posix_shm', 'posix_shm.c'))

compiler = meson.get_compiler('c')
if compiler.get_id() == 'clang' and compiler.get_linker_id() == 'ld.lld'
    guard_none = executable('guard_none', 'cfguard-test.c', c_args: ['-mguard=none'], link_args: ['-Wl,-Xlink,-guard:no'])
    test('guard_none-check_enabled', guard_none, args : ['check_enabled'], should_fail: true)
    test('guard_none-normal_icall', guard_none, args : ['normal_icall'])
    test('guard_none-invalid_icall', guard_none, args : ['invalid_icall'])
    test('guard_none-invalid_icall_nocf', guard_none, args : ['invalid_icall_nocf'])

    guard_cf = executable('guard_cf', 'cfguard-test.c', c_args: ['-mguard=cf'], link_args: ['-Wl,-Xlink,-guard:cf'])
    test('guard_cf-check_enabled', guard_cf, args : ['check_enabled'])
    test('guard_cf-normal_icall', guard_cf, args : ['normal_icall'])
    test('guard_cf-invalid_icall', guard_cf, args : ['invalid_icall'], should_fail: true)
    test('guard_cf-invalid_icall_nocf', guard_cf, args : ['invalid_icall_nocf'])

    guard_cf_nochecks = executable('guard_cf_nochecks', 'cfguard-test.c', c_args: ['-mguard=cf-nochecks'], link_args: ['-Wl,-Xlink,-guard:cf'])
    test('guard_cf_nochecks-check_enabled', guard_cf_nochecks, args : ['check_enabled'])
    test('guard_cf_nochecks-normal_icall', guard_cf_nochecks, args : ['normal_icall'])
    test('guard_cf_nochecks-invalid_icall', guard_cf_nochecks, args : ['invalid_icall'])
    test('guard_cf_nochecks-invalid_icall_nocf', guard_cf_nochecks, args : ['invalid_icall_nocf'])
endif

if not get_option('cross')
    subdir('def-undec-stdcall')
endif