.PHONY: all clean latest older evenolder

all: latest older evenolder

latest:
	rm -Rf _build_latest
	WANT_AUTOCONF='latest' WANT_AUTOMAKE='latest' ./build.sh _build_latest

older:
	rm -Rf _build_older
	WANT_AUTOCONF='2.71' WANT_AUTOMAKE='1.16' ./build.sh _build_older

evenolder:
	rm -Rf _build_evenolder
	WANT_AUTOCONF='2.69' WANT_AUTOMAKE='1.15' ./build.sh _build_evenolder

clean:
	rm -rf _build_latest _build_older _build_evenolder
