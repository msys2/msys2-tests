#!/bin/bash

set -e

check_stack_size() {
    # Checks the size of the stack reserved by an executable file and compares it with a specified minimum value.
    #
    # Parameters:
    #   $1 (string): The name/path of the executable file to check.
    #   $2 (integer): The minimum size value for the stack.

    local path
    path="$(command -v "$1")"
    local min_value="$2"

    local line
    line="$(objdump.exe -x "$path" | grep SizeOfStackReserve)"
    local stack_size
    stack_size=$(printf "%d" "0x$(echo "$line" | awk '{print $2}')")

    if (( stack_size < min_value )); then
        echo "Error: Stack size ($stack_size) is lower than $min_value"
        return 1
    fi

    return 0
}

# Make sure GCC doesn't use the default stack size somehow
# Setting BOOT_LDFLAGS would disable it for example
# https://github.com/msys2/MINGW-packages/pull/16968#issuecomment-1545473141
check_stack_size cc.exe 12582912
