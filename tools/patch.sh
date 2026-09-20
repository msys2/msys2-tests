#!/usr/bin/env bash

# Test the MSYS2/Cygwin line-ending behavior of GNU patch.
# Usage: bash test.sh [path-to-patch]
# The PATCH_BIN environment variable can be used instead of the argument.

set -u

patch_bin=${1:-${PATCH_BIN:-patch}}

if [[ "$patch_bin" == */* ]]; then
  if [[ ! -x "$patch_bin" ]]; then
    printf 'patch executable not found: %s\n' "$patch_bin" >&2
    exit 2
  fi
  patch_bin="$(cd "$(dirname "$patch_bin")" && pwd)/$(basename "$patch_bin")"
else
  patch_bin=$(command -v "$patch_bin" || true)
  if [[ -z "$patch_bin" ]]; then
    printf 'patch executable not found\n' >&2
    exit 2
  fi
fi

for command_name in cmp diff mktemp; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'required command not found: %s\n' "$command_name" >&2
    exit 2
  fi
done

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/msys2-patch-test.XXXXXX") || exit 2
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

pass=0
fail=0
case_number=0
case_dir=

new_case() {
  case_number=$((case_number + 1))
  case_dir="$tmpdir/case-${case_number}"
  mkdir "$case_dir"
}

write_patch_from_eol_fixtures() {
  local dir=$1
  local style=$2
  local eol=$'\n'
  [[ "$style" == crlf ]] && eol=$'\r\n'

  printf 'old%s' "$eol" > "$dir/file.orig"
  printf 'new%s' "$eol" > "$dir/file.new"
  (cd "$dir" && diff -u file.orig file.new > patch.diff)
  [[ "$?" -eq 1 ]]
}

write_patch_converted_to_crlf() {
  local dir=$1
  shift

  printf 'old\n' > "$dir/file.orig"
  printf 'new\n' > "$dir/file.new"
  (cd "$dir" && diff "$@" file.orig file.new > patch.diff)
  [[ "$?" -eq 1 ]] || return 1

  while IFS= read -r line; do
    printf '%s\r\n' "$line"
  done < "$dir/patch.diff" > "$dir/patch.crlf"
  mv "$dir/patch.crlf" "$dir/patch.diff"
}

run_patch() {
  local dir=$1
  shift
  (cd "$dir" && "$patch_bin" "$@" < patch.diff >patch.stdout 2>patch.stderr)
}

print_case_output() {
  local output line

  for output in patch.stdout patch.stderr script.stdout script.stderr; do
    [[ -s "$case_dir/$output" ]] || continue
    printf '  %s:\n' "$output"
    while IFS= read -r line || [[ -n "$line" ]]; do
      printf '    %s\n' "$line"
    done < "$case_dir/$output"
  done
}

assert_bytes() {
  local file=$1
  local expected=$2
  printf '%s' "$expected" > "$case_dir/expected"
  cmp -s "$file" "$case_dir/expected"
}

test_apply_lf_patch_to_lf_file() {
  new_case
  printf 'old\n' > "$case_dir/file"
  write_patch_from_eol_fixtures "$case_dir" lf || return 1
  run_patch "$case_dir" -f file || return 1
  assert_bytes "$case_dir/file" $'new\n'
}

test_apply_lf_patch_to_crlf_file() {
  # XXX: patched in MSYS2 to be supported
  new_case
  printf 'old\r\n' > "$case_dir/file"
  write_patch_from_eol_fixtures "$case_dir" lf || return 1
  run_patch "$case_dir" -f file || return 1
  assert_bytes "$case_dir/file" $'new\n'
}

test_apply_lf_patch_to_mixed_eol_file() {
  # XXX: patched in MSYS2 to be supported
  new_case
  printf 'one\r\ntwo\nthree\r\n' > "$case_dir/file"
  printf 'one\ntwo\nthree\n' > "$case_dir/file.orig"
  printf 'one\nnew\nthree\n' > "$case_dir/file.new"
  (cd "$case_dir" && diff -u file.orig file.new > patch.diff)
  [[ "$?" -eq 1 ]] || return 1
  run_patch "$case_dir" -f file || return 1
  assert_bytes "$case_dir/file" $'one\nnew\nthree\n'
}

test_apply_crlf_converted_patch_to_lf_file() {
  new_case
  printf 'old\n' > "$case_dir/file"
  write_patch_converted_to_crlf "$case_dir" -u || return 1
  run_patch "$case_dir" -f file || return 1
  assert_bytes "$case_dir/file" $'new\n'
}

test_apply_crlf_converted_patch_to_crlf_file() {
  # XXX: patched in MSYS2 to be supported
  new_case
  printf 'old\r\n' > "$case_dir/file"
  write_patch_converted_to_crlf "$case_dir" -u || return 1
  run_patch "$case_dir" -f file || return 1
  # This is the historical MSYS2 behavior: O_TEXT normalizes the output to LF.
  assert_bytes "$case_dir/file" $'new\n'
}

test_reject_crlf_patch_for_crlf_file() {
  # FIXME: Broken in MSYS2 due to automatic CRLF to LF conversion
  new_case
  printf 'old\r\n' > "$case_dir/file"
  write_patch_from_eol_fixtures "$case_dir" crlf || return 1
  if run_patch "$case_dir" -f file; then
    return 1
  fi
  assert_bytes "$case_dir/file" $'old\r\n' || return 1
  [[ -f "$case_dir/file.rej" ]]
}

test_apply_lf_patch_from_tty() {
  command -v script >/dev/null 2>&1 || return 1

  new_case
  printf 'old\n' > "$case_dir/file"
  write_patch_from_eol_fixtures "$case_dir" lf || return 1

  local command
  printf -v command '%q -f file' "$patch_bin"
  (cd "$case_dir" && script -qefc "$command" /dev/null \
    < patch.diff >script.stdout 2>script.stderr) || return 1
  assert_bytes "$case_dir/file" $'new\n'
}

test_apply_lf_patch_to_lf_file_in_binary_mode() {
  new_case
  printf 'old\n' > "$case_dir/file"
  write_patch_from_eol_fixtures "$case_dir" lf || return 1
  run_patch "$case_dir" --binary -f file || return 1
  assert_bytes "$case_dir/file" $'new\n'
}

test_reject_lf_patch_for_crlf_file_in_binary_mode() {
  new_case
  printf 'old\r\n' > "$case_dir/file"
  write_patch_from_eol_fixtures "$case_dir" lf || return 1
  if run_patch "$case_dir" --binary -f file; then
    return 1
  fi
  assert_bytes "$case_dir/file" $'old\r\n' || return 1
  [[ -f "$case_dir/file.rej" ]]
}

test_apply_lf_patch_to_mixed_eol_file_in_binary_mode() {
  new_case
  printf 'one\r\ntwo\nthree\r\n' > "$case_dir/file"
  printf 'one\ntwo\nthree\n' > "$case_dir/file.orig"
  printf 'one\nnew\nthree\n' > "$case_dir/file.new"
  (cd "$case_dir" && diff -u file.orig file.new > patch.diff)
  [[ "$?" -eq 1 ]] || return 1
  run_patch "$case_dir" --binary -f file || return 1
  assert_bytes "$case_dir/file" $'one\r\nnew\nthree\r\n'
}

test_reject_crlf_converted_patch_for_lf_file_in_binary_mode() {
  new_case
  printf 'old\n' > "$case_dir/file"
  write_patch_converted_to_crlf "$case_dir" -u || return 1
  if run_patch "$case_dir" --binary -f file; then
    return 1
  fi
  assert_bytes "$case_dir/file" $'old\n' || return 1
  [[ -f "$case_dir/file.rej" ]]
}

test_apply_crlf_converted_patch_to_crlf_file_in_binary_mode() {
  new_case
  printf 'old\r\n' > "$case_dir/file"
  write_patch_converted_to_crlf "$case_dir" -u || return 1
  run_patch "$case_dir" --binary -f file || return 1
  assert_bytes "$case_dir/file" $'new\r\n'
}

test_apply_crlf_patch_to_crlf_file_in_binary_mode() {
  new_case
  printf 'old\r\n' > "$case_dir/file"
  write_patch_from_eol_fixtures "$case_dir" crlf || return 1
  run_patch "$case_dir" --binary -f file || return 1
  assert_bytes "$case_dir/file" $'new\r\n'
}

test_apply_lf_patch_from_tty_in_binary_mode() {
  # XXX: patched in MSYS2 to be supported
  command -v script >/dev/null 2>&1 || return 1

  new_case
  printf 'old\n' > "$case_dir/file"
  write_patch_from_eol_fixtures "$case_dir" lf || return 1

  local command
  printf -v command '%q --binary -f file' "$patch_bin"
  (cd "$case_dir" && script -qefc "$command" /dev/null \
    < patch.diff >script.stdout 2>script.stderr) || return 1
  assert_bytes "$case_dir/file" $'new\n'
}

run_test() {
  local name=$1
  shift
  "$@"
  local status=$?

  if [[ "$status" -eq 0 ]]; then
    printf 'ok   - %s\n' "$name"
    pass=$((pass + 1))
  else
    printf 'FAIL - %s\n' "$name"
    print_case_output
    fail=$((fail + 1))
  fi
}

printf 'Testing: %s\n' "$patch_bin"

printf '\nDefault mode:\n'
run_test 'apply LF patch to LF file' test_apply_lf_patch_to_lf_file
run_test 'apply LF patch to CRLF file [XXX]' test_apply_lf_patch_to_crlf_file
run_test 'apply LF patch to mixed-EOL file [XXX]' test_apply_lf_patch_to_mixed_eol_file
run_test 'apply CRLF-converted patch to LF file' test_apply_crlf_converted_patch_to_lf_file
run_test 'apply CRLF-converted patch to CRLF file [XXX]' test_apply_crlf_converted_patch_to_crlf_file
run_test 'reject CRLF patch for CRLF file [FIXME]' test_reject_crlf_patch_for_crlf_file
run_test 'apply LF patch from a TTY' test_apply_lf_patch_from_tty

printf '\nBinary mode:\n'
run_test 'apply LF patch to LF file' test_apply_lf_patch_to_lf_file_in_binary_mode
run_test 'reject LF patch for CRLF file' test_reject_lf_patch_for_crlf_file_in_binary_mode
run_test 'apply LF patch to mixed-EOL file' test_apply_lf_patch_to_mixed_eol_file_in_binary_mode
run_test 'reject CRLF-converted patch for LF file' test_reject_crlf_converted_patch_for_lf_file_in_binary_mode
run_test 'apply CRLF-converted patch to CRLF file' test_apply_crlf_converted_patch_to_crlf_file_in_binary_mode
run_test 'apply CRLF patch to CRLF file' test_apply_crlf_patch_to_crlf_file_in_binary_mode
run_test 'apply LF patch from a TTY [XXX]' test_apply_lf_patch_from_tty_in_binary_mode

printf '\n%s passed, %s failed\n' "$pass" "$fail"
[[ "$fail" -eq 0 ]]
