project('msys2-toolchain-tests', 'c', 'cpp',
  version : '0.1',
  default_options : [
    'warning_level=3',
    'buildtype=debugoptimized',
  ]
)

add_project_arguments('-Werror', language : ['c', 'cpp'])

subdir('tests')
