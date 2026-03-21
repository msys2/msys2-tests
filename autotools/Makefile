.PHONY: all clean ac_latest_am_latest ac_272_am_117 ac_271_am_116 ac_269_am_115

all: ac_latest_am_latest ac_272_am_117 ac_271_am_116 ac_269_am_115

ac_latest_am_latest:
	rm -Rf _build_ac_latest_am_latest
	WANT_AUTOCONF='latest' WANT_AUTOMAKE='latest' ./build.sh _build_ac_latest_am_latest

ac_272_am_117:
	rm -Rf _build_ac_272_am_117
	WANT_AUTOCONF='2.72' WANT_AUTOMAKE='1.17' ./build.sh _build_ac_272_am_117

ac_271_am_116:
	rm -Rf _build_ac_271_am_116
	WANT_AUTOCONF='2.71' WANT_AUTOMAKE='1.16' ./build.sh _build_ac_271_am_116

ac_269_am_115:
	rm -Rf _build_ac_269_am_115
	WANT_AUTOCONF='2.69' WANT_AUTOMAKE='1.15' ./build.sh _build_ac_269_am_115

clean:
	rm -rf _build_ac_latest_am_latest _build_ac_272_am_117 _build_ac_271_am_116 _build_ac_269_am_115
