import subprocess
import os
import sys
import unittest
from typing import Tuple, List, Dict
from contextlib import contextmanager


DIR = os.path.dirname(os.path.realpath(__file__))


@contextmanager
def set_env(name, value):
    old_value = os.environ.get(name)
    try:
        os.environ[name] = value
        yield
    finally:
        if old_value is None:
            del os.environ[name]
        else:
            os.environ[name] = old_value


def parse_echo(args: List[str]=[], env: Dict[str, str]=os.environ) -> Tuple[List[str], Dict[str, str]]:
    """Returns the arguments and the environment the called process received"""

    data = subprocess.check_output([os.path.join(DIR, 'echo.exe')] + args, env=env)
    parts = data.split(b'\x00')
    num_args = int(parts[0].decode())
    args_bytes = parts[1:1 + num_args]
    args = [a.decode() for a in args_bytes]
    num_env_vars = int(parts[1 + num_args].decode())
    env_vars_bytes = parts[2 + num_args:2 + num_args + num_env_vars]
    env_vars = dict(e.decode().split('=', 1) for e in env_vars_bytes)
    return (args[1:], env_vars)


def cygpath(mode: str, path: str) -> str:
    data = subprocess.check_output(['cygpath', mode, path], text=True)
    return data.splitlines()[0]


class Tests(unittest.TestCase):

    def test_path_root(self):
        root = cygpath('-m', '/')
        args = parse_echo(['/'])[0]
        self.assertEqual(root, args[0])

    def test_env_root(self):
        root = cygpath('-m', '/')
        parsed = parse_echo([], {'FOO': '/'})[1]['FOO']
        self.assertEqual(root, parsed)

    def test_with_spaces(self):
        # https://github.com/git-for-windows/msys2-runtime/commit/0b2d287629
        mroot = cygpath('-m', '/')
        parsed = parse_echo(['/foo bar'], {})[0][0]
        self.assertEqual(parsed, mroot + "foo bar")

        wroot = cygpath('-w', '/')
        parsed = parse_echo(['/foo bar:/baz quux'], {})[0][0]
        self.assertEqual(parsed, wroot + "foo bar;" + wroot + "baz quux")

    def test_disable_everything(self):
        with set_env('MSYS_NO_PATHCONV', '1'):
            args, envs = parse_echo(['/usr', 'adad'], {'FOO': '/bla'})
        self.assertEqual(args, ['/usr', 'adad'])
        self.assertEqual(envs['FOO'], '/bla')

    def test_pass_string_to_preprocessor(self):
        # https://github.com/msys2/msys2-runtime/issues/190
        parsed = parse_echo(['-DPREFIX="/ucrt64"'], {})[0][0]
        mroot = cygpath('-m', '/')
        self.assertEqual(parsed, f'-DPREFIX="{mroot}ucrt64"')


def suite():
    return unittest.TestLoader().loadTestsFromName(__name__)


if __name__ == '__main__':
    # We depend on this being cygwin Python
    assert sys.platform == 'cygwin'
    unittest.main(defaultTest='suite')