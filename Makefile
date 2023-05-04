.PHONY: toolchain rust python cmake autotools golang fortran ruby perl nodejs runtime ada tools

all: toolchain rust python cmake autotools golang fortran ruby perl nodejs runtime ada tools

toolchain:
	(cd toolchain && ./test.sh)

rust:
	(cd rust && ./test.sh)

python:
	(cd python && ./test.sh)

cmake:
	(cd cmake && ./test.sh)

autotools:
	(cd autotools && ./test.sh)

golang:
	(cd golang && ./test.sh)

fortran:
	(cd fortran && ./test.sh)

ruby:
	(cd ruby && ./test.sh)

perl:
	(cd perl && ./test.sh)

nodejs:
	(cd nodejs && ./test.sh)

runtime:
	(cd runtime && ./test.sh)

ada:
	(cd ada && ./test.sh)

tools:
	(cd tools && ./test.sh)
