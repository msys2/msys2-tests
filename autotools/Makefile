.PHONY: all clean latest older

all: latest older

latest:
	rm -Rf _build_latest
	WANT_AUTOCONF='latest' WANT_AUTOMAKE='latest' ./build.sh _build_latest

older:
	rm -Rf _build_older
	WANT_AUTOCONF='2.69' WANT_AUTOMAKE='1.15' ./build.sh _build_older

clean:
	rm -rf _build_latest _build_older
