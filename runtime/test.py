import subprocess
import os
import sys
import unittest
from typing import Tuple, List, Dict


DIR = os.path.dirname(os.path.realpath(__file__))


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


def suite():
    return unittest.TestLoader().loadTestsFromName(__name__)


if __name__ == '__main__':
    # We depend on this being cygwin Python
    assert sys.platform == 'cygwin'
    unittest.main(defaultTest='suite')