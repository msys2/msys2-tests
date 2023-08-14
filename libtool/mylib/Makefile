LIB=mylib
LIBNAME=lib$(LIB).la
HEADER=mylib.h
DESTDIR ?=
LIBPATH ?= /lib
INCPATH ?= /include
BUILDDIR ?= build

all: ${LIBNAME}

$(BUILDDIR)/$(LIB).o: $(HEADER)
	libtool --mode=compile --tag=CC $(CC) $(CFLAGS) $(LDFLAGS) -o $(BUILDDIR)/$(LIB).o -c $(LIB).c

$(LIBNAME): $(BUILDDIR)/$(LIB).o
	libtool --mode=link --tag=CC $(CC) $(LDFLAGS) $(BUILDDIR)/$(LIB).lo -o $(BUILDDIR)/$(LIBNAME) -rpath $(LIBPATH) -version-info 42 -no-undefined

install: $(LIBNAME)
	install -d $(DESTDIR)$(LIBPATH)
	install -d $(DESTDIR)$(INCPATH)
	libtool --mode=install install -m 644 $(BUILDDIR)/$(LIBNAME) $(DESTDIR)$(LIBPATH)/$(LIBNAME)
	install -m 644 $(HEADER) $(DESTDIR)$(INCPATH)
