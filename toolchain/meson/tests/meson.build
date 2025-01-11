test('huge_val', executable('huge_val', 'huge_val.c'))
test('snprintf_redef', executable('snprintf_redef', 'snprintf_redef.c'))
test('quick_exit', executable('quick_exit', 'quick_exit.cpp'))
test('exception_handling', executable('exception_handling', 'exception_handling.cpp'))
test('printf_format', executable('printf_format', 'printf_format.c'))
# FIXME: c++11 to work around gcc 15 git failing on its own deprecation warnings
test('pch', executable('pch', 'pch.cpp', cpp_pch : 'pch/pch.hpp', override_options : ['cpp_std=c++11']))
test('libcpp_long_double', executable('libcpp_long_double', 'libcpp_long_double.cpp'))


openmp = dependency('openmp', required: get_option('openmp'))
if openmp.found()
    env = environment()
    env.set('OMP_NUM_THREADS', '1')
    test('openmp_for_if', executable('openmp_for_if', 'openmp_for_if.c', dependencies : [openmp]), env : env)
endif
test('pow', executable('pow', 'pow.c', c_args: ['-fno-builtin', '-fno-strict-aliasing']))

windres_res = import('windows').compile_resources('windres.rc')
windres = executable('windres', 'windres.c', windres_res)
test('windres', windres)

test('call_once', executable('call_once', 'call_once.cpp'))

test('undef_memrchr', executable('undef_memrchr', 'undef_memrchr.c', c_args: ['-O3']))

test('stpcpy_fortify', executable('stpcpy_fortify', 'stpcpy_fortify.c', c_args: ['-O3', '-D_FORTIFY_SOURCE=2']))

test('stackprotector_custom', executable('stackprotector_custom', 'stackprotector_custom.c', c_args: ['-O0', '-fstack-protector-strong']))

test('cygwin_wmemset', executable('cygwin_wmemset', 'cygwin_wmemset.c'))

test('posix_sem', executable('posix_sem', 'posix_sem.c', dependencies: [dependency('threads')]))

test('posix_sem_named', executable('posix_sem_named', 'posix_sem_named.c', dependencies: [dependency('threads')]))

test('posix_shm', executable('posix_shm', 'posix_shm.c'))

test('wcstok_nonconform', executable('wcstok_nonconform', 'wcstok_nonconform.c'))

test('wildcard_on', executable('wildcard_on', 'wildcard.c', c_args: ['-DDO_WILDCARD=1']), args : ['tests/wildc*_on.exe'])
test('wildcard_off', executable('wildcard_off', 'wildcard.c', c_args: ['-DDO_WILDCARD=0']), args : ['tests/wildc*_on.exe'])
test('wildcard_default', executable('wildcard_default', 'wildcard.c'), args : ['tests/wildc*_on.exe'])

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

subdir('def-undec-stdcall')
subdir('ices')