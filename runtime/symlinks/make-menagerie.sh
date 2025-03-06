#!/bin/bash -e

# needs: coreutils

mkdir menagerie && cd menagerie

echo "this is a regular file" > file
mkdir dir
mknod block b 8 0
mknod char c 1 3
mkfifo fifo

# making a socket isn't as straightforward
#(timeout 0.1 nc -klU socket || test $? -eq 124 && test -S socket)
# python is already installed for other tests
python -c "import socket as s; s.socket(s.AF_UNIX).bind('socket')"

# make a directory junction using cmd, since I don't think there's a cygwin
# way to do it
cmd //c "mklink /j dirjunction dir"

for wsym in lnk sys nativestrict deepcopy; do
	for dst in file dir dirjunction block char fifo socket; do
		MSYS=winsymlinks:${wsym} ln -s ${dst} ${dst}${wsym}
	done
done
