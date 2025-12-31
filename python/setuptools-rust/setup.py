#!/usr/bin/env python

from setuptools import setup
from setuptools_rust import Binding, RustExtension

setup(
    name="setuptools_rust_test",
    version="0.1.0",
    rust_extensions=[RustExtension("setuptools_rust_test._lib", binding=Binding.PyO3)],
    packages=["setuptools_rust_test"],
    zip_safe=False,
)