#!/usr/bin/env bash

# Regression tests for MSYS2's restored DOS text handling.
# Usage: bash grep.sh [path-to-grep], or set GREP_BIN.
# Use MSYS grep even when a native MinGW grep is earlier in PATH.

set -e -u -o pipefail
export LC_ALL=C
unset GREP_OPTIONS GREP_COLORS

grep_bin=${1:-${GREP_BIN:-/usr/bin/grep}}
if [[ "$grep_bin" == */* ]]; then
    grep_bin="$(cd "$(dirname "$grep_bin")" && pwd)/$(basename "$grep_bin")"
else
    grep_bin=$(command -v "$grep_bin")
fi
if [[ ! -x "$grep_bin" ]]; then
    printf 'grep executable not found: %s\n' "$grep_bin" >&2
    exit 2
fi

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/msys2-grep-test.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT
cd "$tmpdir"

pass=0
fail=0

# Never capture grep output in command substitution: MSYS2 Bash can strip
# carriage returns there, even with igncr disabled. printf %b also lets us
# create expected output containing NUL bytes without storing them in a variable.
check() {
    local name=$1 expected_status=$2 expected_bytes=$3 status=0
    shift 3
    printf '%b' "$expected_bytes" > expected
    "$@" > actual 2> stderr || status=$?
    if [[ "$status" -eq "$expected_status" ]] && cmp -s expected actual; then
        printf 'ok   - %s\n' "$name"
        pass=$((pass + 1))
    else
        printf 'FAIL - %s (status %s, expected %s)\n' "$name" "$status" "$expected_status"
        printf '  expected bytes:\n'
        od -An -tx1 expected
        printf '  actual bytes:\n'
        od -An -tx1 actual
        cat stderr >&2
        fail=$((fail + 1))
    fi
}

grep_stdin() {
    "$grep_bin" "$@" < input
}

grep_pipe() {
    cat input | "$grep_bin" "$@"
}

test_libtool() {
    # A trailing CR on the final crtend.o token broke libtool's *.o detection.
    # https://github.com/msys2/MSYS2-packages/issues/1353
    # https://github.com/msys2/MINGW-packages/issues/9771
    printf 'crtend.o\r\n' > input
    check 'CRLF object-file suffix matches and loses its trailing CR' 0 \
        'crtend.o\n' grep_pipe '\.o$'
}

test_crlf() {
    # Preserve the CRLF compatibility that blocked earlier upgrades.
    # https://github.com/msys2/MSYS2-packages/pull/2163
    printf 'first\r\nsecond\r\n' > input
    # Cover each matcher and input mode.
    check 'CRLF file, basic regex anchors' 0 'first\n' \
        "$grep_bin" -G '^first$' input
    check 'CRLF redirected stdin, extended regex' 0 'first\n' \
        grep_stdin -Ex first
    check 'CRLF pipe, fixed string' 0 'first\n' grep_pipe -Fx first
    check 'CRLF pipe, PCRE' 0 'first\n' grep_pipe -Px first
    check '-U preserves raw CRLF bytes' 0 'first\r\nsecond\r\n' \
        "$grep_bin" -U '^' input
    check '-U disables CRLF whole-line matching' 1 '' \
        "$grep_bin" -U -Fx first input

    printf 'first\r\n' > patterns
    check 'CRLF pattern file' 0 'first\n' "$grep_bin" -f patterns input
}

test_offsets() {
    # -b counts physical bytes; -u counts bytes after CR removal.
    printf 'a\r\nb\nc\r\n' > input
    check 'physical offsets with mixed line endings' 0 '0:a\n3:b\n5:c\n' \
        "$grep_bin" -b '^' input
    check 'Unix offsets with mixed line endings' 0 '0:a\n2:b\n4:c\n' \
        "$grep_bin" -bu '^' input
    check 'physical match offset with -o' 0 '5:c\n' "$grep_bin" -bo c input
}

test_classification() {
    # A NUL prevents conversion even with -a. A CRLF classifies DOS text,
    # whose lone CRs are also stripped; LF-only text keeps its lone CRs.
    printf 'first\r\n\0second\r\n' > input
    check 'NUL prevents DOS conversion even with -a' 0 'first\r\n\0second\r\n' \
        "$grep_bin" -a '^' input
    printf 'one\rtwo\r\n' > input
    check 'DOS text strips embedded lone CR' 0 'onetwo\n' "$grep_bin" '^' input
    printf 'one\rtwo\n' > input
    check 'LF text preserves lone CR' 0 'one\rtwo\n' "$grep_bin" '^' input
    printf 'a\r\n' > input
    printf 'b\rx\n' > input2
    check 'classification and offsets reset between files' 0 '0:a\n0:b\rx\n' \
        "$grep_bin" -hb '^' input input2
}

test_buffer_boundaries() {
    # Split CRLF at grep 3.12's initial 96 KiB read boundary. This remains
    # a valid empty-record test if a future version changes the buffer size.
    # https://github.com/msys2/MSYS2-packages/commit/04ebad07bee79f5f94a5c2b502c35892dd13c60a
    awk 'BEGIN {
        printf "a\r\n"
        for (i = 0; i < 98299; i++) printf "b"
        printf "\n\r\n"
    }' > input
    check 'empty CRLF record at a read boundary' 0 '98303:\n' \
        "$grep_bin" -bx '' input
}

main() {
    printf 'Testing: %s\n' "$grep_bin"
    "$grep_bin" --version

    printf '\nHistorical MSYS2 compatibility:\n'
    test_libtool
    test_crlf
    test_offsets
    test_classification
    test_buffer_boundaries

    printf '\n%s passed, %s failed\n' "$pass" "$fail"
    [[ "$fail" -eq 0 ]]
}

main
