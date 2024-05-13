c_compiler_program = find_program(meson.get_compiler('c').cmd_array().get(-1))
cpp_compiler_program = find_program(meson.get_compiler('cpp').cmd_array().get(-1))

test('ice-gcc-115038-1',
     cpp_compiler_program, args: [
        '-c', '-O2', '-fno-omit-frame-pointer',
        meson.current_source_dir() / 'gcc-115038-1.cpp'
    ])

test('ice-gcc-115038-2',
     cpp_compiler_program, args: [
        '-c', '-O2', '-fno-omit-frame-pointer',
        meson.current_source_dir() / 'gcc-115038-2.cpp'
    ])

test('ice-gcc-115038-3',
     c_compiler_program, args: [
        '-c', '-O2',
        meson.current_source_dir() / 'gcc-115038-3.c'
    ])
