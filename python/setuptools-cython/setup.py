from setuptools import setup
from Cython.Build import cythonize

setup(
    name='cwrapper-cython',
    version='1.0',
    ext_modules=cythonize("hello.pyx", force=True, language_level=3),
)
