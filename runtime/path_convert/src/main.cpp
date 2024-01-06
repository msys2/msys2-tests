/*
SPDX-License-Identifier: CC0-1.0
*/

#include "path_conv.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/***************************************************************************/

typedef struct test_data_t {
    const char *src;
    const char *dst;
    bool fail;
} test_data;

#ifdef MSYSROOT
#ifndef MSYSROOT2
#error "Need to define both MSYSROOT and MSYSROOT2, or neither"
#endif
#else
#ifdef MSYSROOT
#error "Need to define both MSYSROOT and MSYSROOT2, or neither"
#endif
#if defined(__MSYS__) && defined(__LP64__)
#define MSYSROOT "C:\\msys64"
#define MSYSROOT2 "C:/msys64"
#else
#define MSYSROOT "C:\\msys32"
#define MSYSROOT2 "C:/msys32"
#endif
#endif

static const test_data datas[] = {
    {"/usr/lib:/var:", MSYSROOT "\\usr\\lib;" MSYSROOT "\\var;", false}
    ,{"-LIBPATH:../lib", "-LIBPATH:../lib", false}
    ,{"-LIBPATH:../lib:/var", "-LIBPATH:../lib:/var", false}
    ,{"//Collection:http://tfsserver", "//Collection:http://tfsserver", false}
    ,{"/Collection:http://tfsserver", "/Collection:http://tfsserver", false}
    ,{"-L'/foo bar/boo' PREFIX='/foo bar/boo'", "-L'/foo bar/boo' PREFIX='/foo bar/boo'", false}
    ,{"-L'/foo /bar/boo' PREFIX='/foo /bar/boo'", "-L'/foo /bar/boo' PREFIX='/foo /bar/boo'", false}
    ,{"C:\\foo\\bar", "C:\\foo\\bar", false} // 0
    ,{"/foo/bar;", "/foo/bar;", false} // 1
    ,{"//foobar", "/foobar", false} // 2
    ,{"//foo\\bar", "/foo/bar", false} // 3
    ,{"//foo/bar", "//foo/bar", false} // 4
    ,{"/c:\\foo\\bar", "c:/foo/bar", false} // 5
    ,{"foo=/bar", "foo=" MSYSROOT2 "/bar", false} // 6
    ,{"-foo,/bar", "-foo," MSYSROOT2 "/bar", false} // 7
    ,{"-I/foo,/bar", "-I/foo," MSYSROOT2 "/bar", false} // 8
    ,{"-I/foo", "-I" MSYSROOT2 "/foo", false} // 9
    ,{"-L/foo", "-L" MSYSROOT2 "/foo", false} // 9
    ,{"-L'/foo /bar'", "-L'/foo /bar'", false} // 9
    ,{"-L/foo /bar", "-L" MSYSROOT2 "/foo /bar", false} // 9
    ,{"-L/foo bar", "-L" MSYSROOT2 "/foo bar", false} // 9
    ,{"-L'/foo bar'", "-L'/foo bar'", false} // 9
    ,{"'/opt /bin'", "'/opt /bin'", false}
    ,{"'/opt files/bin'", "'/opt files/bin'", false}
    ,{"/", "" MSYSROOT2 "/", false} // 10
    ,{"/..", "/..", false} // 11
    ,{"x:x:/x", "x:x:/x", false} // 12
    ,{"x::x:/xx", "x::x:/xx", false} // 13
    ,{"x::x/z:x", "x::x/z:x", false} // 14
    ,{"x::/x z:x", "x::/x z:x", false} // 14
    ,{"'x::/x z:x'", "'x::/x z:x'", false} // 14
    ,{"/dev/null", "nul", false} // 14
    ,{"/var:/var", MSYSROOT "\\var;" MSYSROOT "\\var", false} // 14
    ,{"'/var:/var'", "'/var:/var'", false} // 14
    ,{"-L'/var:/var'", "-L'/var:/var'", false} // 14
    ,{"-L/var:/var", "-L" MSYSROOT "\\var;" MSYSROOT "\\var", false} // 14
    ,{"'/bin:/Program Files:/lib'", "'/bin:/Program Files:/lib'", false}
    ,{"/bin:/Program Files:/lib", "" MSYSROOT "\\usr\\bin;" MSYSROOT "\\Program Files;" MSYSROOT "\\lib", false}
    ,{"-L/opt /bin", "-L" MSYSROOT2 "/opt /bin", false}
    ,{"'-L/opt /bin'", "'-L/opt /bin'", false}
    ,{"-w -- INSTALL_ROOT=C:/Test/ports64", "-w -- INSTALL_ROOT=C:/Test/ports64", false} // 15
    ,{"-w -- INSTALL_ROOT=C:\\Test\\ports64", "-w -- INSTALL_ROOT=C:\\Test\\ports64", false} // 16
    ,{"-IC:/Test/ports64", "-IC:/Test/ports64", false} // 17
    //,{"-g -O2 -I/foo -L/foo PREFIX=/foo", "-g -O2 -I" MSYSROOT2 "/foo -L" MSYSROOT2 "/foo PREFIX=" MSYSROOT2 "/foo", false}
    //,{"-g -O2 -I/foo -L'/foo bar/boo' PREFIX='/foo bar/boo'", "-g -O2 -I" MSYSROOT2 "/foo -L'" MSYSROOT2 "/foo bar/boo' PREFIX='" MSYSROOT2 "/foo bar/boo'", false}
    ,{"'C:\\foo\\bar'", "'C:\\foo\\bar'", false} // 0
    ,{"'/foo/bar;'", "'/foo/bar;'", false} // 1
    ,{"'//foobar'", "'//foobar'", false} // 2
    ,{"'//foo\\bar'", "'//foo\\bar'", false} // 3
    ,{"'//foo/bar'", "'//foo/bar'", false} // 4
    ,{"'/c:\\foo\\bar'", "'/c:\\foo\\bar'", false} // 5
    ,{"foo=/bar", "foo=" MSYSROOT2 "/bar", false} // 6
    ,{"'foo=/bar'", "'foo=/bar'", false} // 6
    ,{"-foo,/bar", "-foo," MSYSROOT2 "/bar", false} // 7
    ,{"'-foo,/bar'", "'-foo,/bar'", false} // 7
    ,{"'-I/foo,/bar'", "'-I/foo,/bar'", false} // 8
    ,{"'-I/foo'", "'-I/foo'", false} // 9
    ,{"'/'", "'/'", false} // 10
    ,{"'/..'", "'/..'", false} // 11
    ,{"'x:x:/x'", "'x:x:/x'", false} // 12
    ,{"'x::x:/x'", "'x::x:/x'", false} // 13
    ,{"'-w -- INSTALL_ROOT=C:/Test/ports64'", "'-w -- INSTALL_ROOT=C:/Test/ports64'", false} // 15
    ,{"'-w -- INSTALL_ROOT=C:\\Test\\ports64'", "'-w -- INSTALL_ROOT=C:\\Test\\ports64'", false} // 16
    ,{"'-IC:/Test/ports64'", "'-IC:/Test/ports64'", false} // 17
    ,{"http://google.ru", "http://google.ru", false}
    ,{"'http://google.ru'", "'http://google.ru'", false}
    ,{"'-I/foo,http://google.ru'", "'-I/foo,http://google.ru'", false} // 8
    ,{"'x::http://google.ru:x'", "'x::http://google.ru:x'", false} // 8
    ,{"", "", false}
    ,{"''", "''", false}
    ,{"/usr/local/info:/usr/share/info:/usr/info:", MSYSROOT "\\usr\\local\\info;" MSYSROOT "\\usr\\share\\info;" MSYSROOT "\\usr\\info;", false}
    ,{"as_nl=\r", "as_nl=\r", false}
    ,{"as_nl=\n", "as_nl=\n", false}
    ,{"as_nl= ", "as_nl= ", false}
    ,{"as_nl='\r'", "as_nl='\r'", false}
    ,{"as_nl='\n'", "as_nl='\n'", false}
    ,{"as_nl=' '", "as_nl=' '", false}
    ,{"C:/Test/ports64", "C:/Test/ports64", false}
    ,{"'C:/Test/ports64'", "'C:/Test/ports64'", false}
    ,{"('" MSYSROOT2 "')", "('" MSYSROOT2 "')", false}
    ,{"--implib=./libblah.a", "--implib=./libblah.a", false}
    ,{"'--implib=./libblah.a'", "'--implib=./libblah.a'", false}
    ,{"--implib=../lib/libblah.a", "--implib=../lib/libblah.a", false}
    ,{"'--implib=../lib/libblah.a'", "'--implib=../lib/libblah.a'", false}
    //,{"    /foo", "    " MSYSROOT2 "/foo", false}
    //,{"'    /foo'", "'    " MSYSROOT2 "/foo'", false}
    //,{"files = '''__init__.py z/codegen.py b/codegen_main.py codegen_docbook.py config.py dbustypes.py parser.py utils.py''' \n", "files = '''__init__.py z/codegen.py b/codegen_main.py codegen_docbook.py config.py dbustypes.py parser.py utils.py''' \n", false}
    ,{
        "import sys\n"
        "import os\n"
        "\n"
        "def main():\n"
        "    print sys.argv\n"
        "    print os.path.exists('some/path')\n"
        "    print os.path.exists('/some/path')\n"
        "\n"
        "if __name__ == '__main__':\n"
        "    main()\n",
        "import sys\n"
        "import os\n"
        "\n"
        "def main():\n"
        "    print sys.argv\n"
        "    print os.path.exists('some/path')\n"
        "    print os.path.exists('/some/path')\n"
        "\n"
        "if __name__ == '__main__':\n"
        "    main()\n", false
    }
    ,{
        "import sys\n"
        "import os\n"
        "\n"
        "def main():\n"
        "    print sys.argv\n"
        "    print os.path.exists('some/path')\n"
        "    print os.path.exists('/some/path')\n"
        "\n"
        "if __name__ == '__main__':\n"
        "    main()\n",
        "import sys\n"
        "import os\n"
        "\n"
        "def main():\n"
        "    print sys.argv\n"
        "    print os.path.exists('some/path')\n"
        "    print os.path.exists('/some/path')\n"
        "\n"
        "if __name__ == '__main__':\n"
        "    main()\n", true
    }
    ,{"E:/msys64/home/Wayne/src/kicad/product/common/gal/opengl/shader.vert;E:/msys64/home/Wayne/src/kicad/product/common/gal/opengl/shader.frag", "E:/msys64/home/Wayne/src/kicad/product/common/gal/opengl/shader.vert;E:/msys64/home/Wayne/src/kicad/product/common/gal/opengl/shader.frag", false}
    ,{"'E:/msys64/home/Wayne/src/kicad/product/common/gal/opengl/shader.vert;E:/msys64/home/Wayne/src/kicad/product/common/gal/opengl/shader.frag'", "'E:/msys64/home/Wayne/src/kicad/product/common/gal/opengl/shader.vert;E:/msys64/home/Wayne/src/kicad/product/common/gal/opengl/shader.frag'", false}
    ,{"-IC:/msys64/mingw64/include", "-IC:/msys64/mingw64/include", false}
    ,{"E:/msys64/home/Wayne/src/kicad/product/common/gal/opengl/shader.vert", "E:/msys64/home/Wayne/src/kicad/product/common/gal/opengl/shader.vert", false}
    ,{"-//OASIS//DTD", "-//OASIS//DTD", false}
    ,{"-DCMAKE_INSTALL_PREFIX:PATH=/bb/pkg/mingw", "-DCMAKE_INSTALL_PREFIX:PATH=" MSYSROOT2 "/bb/pkg/mingw", false}
    ,{"-DCMAKE_INSTALL_PREFIX=/bb/pkg/mingw", "-DCMAKE_INSTALL_PREFIX=" MSYSROOT2 "/bb/pkg/mingw", false}
    ,{"foo:echo /bar/baz", "foo:echo /bar/baz", false}
    ,{"@/foo/bar", "@" MSYSROOT2 "/foo/bar", false}
    ,{"@/foo/bar@", "@" MSYSROOT2 "/foo/bar@", false}
    ,{"'@/foo/bar'", "'@/foo/bar'", false}
    ,{"///foo/bar", "//foo/bar", false}
    ,{".:./", ".:./", false}
    ,{"..:./", "..:./", false}
    ,{"../:./", "../:./", false}
    ,{"../aa/:./", "../aa/:./", false}
    ,{"../", "../", false}
    ,{"/foo/bar/", "" MSYSROOT2 "/foo/bar/", false}
    ,{"-MExtUtils::ParseXS=process_file", "-MExtUtils::ParseXS=process_file", false}
    ,{"/foo/bin/../libs", "" MSYSROOT2 "/foo/bin/../libs", false}
    ,{"'/foo/bin/../libs'", "'/foo/bin/../libs'", false}
    ,{"ExtUtils::ParseXS::process_file(filename => \"$<\", output => \"$@\", typemap => \"$(PURPLE_PERL_TOP)/common/typemap\");",
        "ExtUtils::ParseXS::process_file(filename => \"$<\", output => \"$@\", typemap => \"$(PURPLE_PERL_TOP)/common/typemap\");", false
    }
    ,{"-Wl,test/path", "-Wl,test/path", false}
    ,{"-Wl,/test/path", "-Wl," MSYSROOT2 "/test/path", false}
    ,{"-Wl,--out-implib,64/shlib/libgcc_s.a.tmp", "-Wl,--out-implib,64/shlib/libgcc_s.a.tmp", false}
    ,{"-Wl,--out-implib,_64/shlib/libgcc_s.a.tmp", "-Wl,--out-implib,_64/shlib/libgcc_s.a.tmp", false}
    ,{"/64/shlib/libgcc_s.a.tmp", "" MSYSROOT2 "/64/shlib/libgcc_s.a.tmp", false}
    ,{"-DVERSION_SOURCES=VERSION;C:/repo/mingw-w64-innoextract/src/innoextract-1.5/VERSION;LICENSE;C:/repo/mingw-w64-innoextract/src/innoextract-1.5/LICENSE", "-DVERSION_SOURCES=VERSION;C:/repo/mingw-w64-innoextract/src/innoextract-1.5/VERSION;LICENSE;C:/repo/mingw-w64-innoextract/src/innoextract-1.5/LICENSE", false}
    ,{"'-DVERSION_SOURCES=VERSION;C:/repo/mingw-w64-innoextract/src/innoextract-1.5/VERSION;LICENSE;C:/repo/mingw-w64-innoextract/src/innoextract-1.5/LICENSE'", "'-DVERSION_SOURCES=VERSION;C:/repo/mingw-w64-innoextract/src/innoextract-1.5/VERSION;LICENSE;C:/repo/mingw-w64-innoextract/src/innoextract-1.5/LICENSE'", false}
    // some spaces in unix paths: https://github.com/git-for-windows/msys2-runtime/commit/0b2d287629
    ,{"/foo bar", MSYSROOT2 "/foo bar", false}
    ,{"/foo bar:/baz quux", MSYSROOT "\\foo bar;" MSYSROOT "\\baz quux", false}
    ,{"/trash directory.t0123-blub:/", MSYSROOT "\\trash directory.t0123-blub;" MSYSROOT "\\", false}
    ,
    // https://github.com/msys2/msys2-runtime/commit/7f5ce2cb55bf18020a68f88c2861ea862feb8178
    {"~/foo", "~/foo", false},
    {"~/.gitconfig", "~/.gitconfig", false},
    // https://github.com/msys2/msys2-runtime/commit/4b20e4fc67735ce82bb47c60a6e8f46bbcb33127
    {":name", ":name", false},
    {":/message", ":/message", false},
    // https://github.com/msys2/msys2-runtime/commit/cfc7696e0825563fb4245377ab70887cde160cd1
    {"`/foo", "`/foo", false},
    {"'/foo", "'/foo", false},
    {"\"/foo", "\"/foo", false},
    {"*/foo", "*/foo", false},
    {"?/foo", "?/foo", false},
    {"[/foo", "[/foo", false},
    {"]/foo", "]/foo", false},
    // https://github.com/msys2/msys2-runtime/commit/6ed5a4279665baad20f30017adb38c6fcec3c2d3
    {"host:/~repo", "host:/~repo", false},
    {"host:/~re:po", "host:/~re:po", false},
    {"host:/~re/po", "host:/~re/po", false},
    {"host:/~repo", "host:/~repo", false},
    // https://github.com/msys2/msys2-runtime/commit/c94cf814671d0c2891d9f82495c42608b39ef5bd
    {"helper:://hostname/subrepo", "helper:://hostname/subrepo", false},
    {"helper:://subrepo", "helper:://subrepo", false},
    {"helper::/subrepo", "helper::/subrepo", false},
    // https://github.com/msys2/msys2-runtime/commit/9944652c41fb96f555d221865f4ed5d0c8b33514
    {"HEAD:./path", "HEAD:./path", false},
    {"HEAD:../path", "HEAD:../path", false},
    // https://github.com/msys2/msys2-runtime/commit/dba012d3e739305f4c08068a330cfe5db885dad6
    {"@@/at-test", "@@/at-test", false},
    // https://github.com/msys2/msys2-runtime/commit/e9a55f1ac61a079533fa01a3dad2b65e721d13f3
    {"me@example.com:/tmp/", "me@example.com:/tmp/", false},
    {"host:/", "host:/", false},
    {"user@host:/", "user@host:/", false},
    {".:/tmp/", ".;" MSYSROOT "\\tmp\\", false},
    {"..:/tmp/", "..;" MSYSROOT "\\tmp\\", false},
    {".:..:/tmp/", ".;..;" MSYSROOT "\\tmp\\", false},
    {"/:/tmp/", MSYSROOT "\\;" MSYSROOT "\\tmp\\", false},
    {0, 0, false}
};

/***************************************************************************/

const char* escape(const char* str, char* dst) {
    char* tmp = dst;
    for (; str != NULL && *str != '\0'; ++str) {
        switch(*str) {
        case '\r':
            *(tmp++) = '\\';
            *(tmp++)='r';
            break;
        case '\n':
            *(tmp++) = '\\';
            *(tmp++)='n';
            break;
        case '\b':
            *(tmp++) = '\\';
            *(tmp++)='b';
            break;
        case '\t':
            *(tmp++) = '\\';
            *(tmp++)='t';
            break;
        default:
            *(tmp++) = *str;
        }
    }
    *tmp = '\0';
    return dst;
}

void litter_buffer(char* buf, size_t len) {
    for (size_t p = 0; p != len; ++p) {
        buf[p] = p + 1;
    }
}

int main() {
    int passed = 0;
    int total = 0;
    for ( const test_data *it = &datas[0]; it && it->src; ++it ) {
        total += 1;
        const char *path = it->src;
        const size_t blen = strlen(it->dst)*2 + 10;
        char *buf = (char*)malloc(blen + 1);
        litter_buffer(buf, blen);

        const char *res = convert(buf, blen, path);
        if ( 0 != strcmp(res, it->dst)) {
            char epath[1024];
            char eres[1024];
            char edst[1024];
            printf("test %ld failed: src=\"%s\", dst=\"%s\" expect=\"%s\"\n", (it - &datas[0]), escape(path, epath), escape(res, eres), escape(it->dst, edst));
            if (it->fail) {
                passed += 1;
            }
        } else {
            char epath[1024];
            char eres[1024];
            passed += 1;
            printf("test %ld passed: src=\"%s\", dst=\"%s\"\n", (it - &datas[0]), escape(path, epath), escape(res, eres));
        }

        free(buf);
    }

    printf("%d out of %d passed, %d failed\n", passed, total, total - passed);

    return total != passed;
}

/***************************************************************************/
