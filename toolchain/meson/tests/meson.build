test('huge_val', executable('huge_val', 'huge_val.c'))
test('snprintf_redef', executable('snprintf_redef', 'snprintf_redef.c'))
test('quick_exit', executable('quick_exit', 'quick_exit.cpp'))
test('exception_handling', executable('exception_handling', 'exception_handling.cpp'))
test('printf_format', executable('printf_format', 'printf_format.c'))
test('pch', executable('pch', 'pch.cpp', cpp_pch : 'pch/pch.hpp'))

openmp = dependency('openmp')
env = environment()
env.set('OMP_NUM_THREADS', '1')
test('openmp_for_if', executable('openmp_for_if', 'openmp_for_if.c', dependencies : [openmp]), env : env)
test('pow', executable('pow', 'pow.c', c_args: ['-fno-builtin', '-fno-strict-aliasing']))

windres_res = import('windows').compile_resources('windres.rc')
windres = executable('windres', 'windres.c', windres_res)
test('windres', windres)

test('call_once', executable('call_once', 'call_once.cpp'))

test('undef_memrchr', executable('undef_memrchr', 'undef_memrchr.c', c_args: ['-O3']))
