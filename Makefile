.PHONY: toolchain rust python cmake autotools golang fortran

all: toolchain rust python cmake autotools golang fortran

toolchain:
	(cd toolchain && ./test.sh)

rust:
	(cd rust && ./test.sh)

python:
	(cd python/setuptools-cext && ./test.sh)

cmake:
	(cd cmake && ./test.sh)

autotools:
	(cd autotools && ./test.sh)

golang:
	(cd golang && ./test.sh)

fortran:
	(cd fortran && ./test.sh)
