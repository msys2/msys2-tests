from setuptools import setup, Extension

setup(
    name='cwrapper',
    version='1.0',
    ext_modules=[
        Extension(
            'cwrapper',
            sources=['cwrapper.c']),
    ],
)
