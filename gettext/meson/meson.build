project('gettext-tests', 'c',
  version : '0.1',
  default_options : ['warning_level=3'])

intl_dep = dependency('intl')

exe = executable('test_snprintf_i64u', 'test_snprintf_i64u.c', dependencies : [intl_dep])

test('test_snprintf_i64u', exe)
