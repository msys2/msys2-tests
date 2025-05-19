#!/bin/bash

set -e

# Check all our shells and that they can execute the login/startup scripts
for sh in bash zsh dash fish ksh; do
    echo "Testing $sh: LOGIN"
    "$sh" -lc "[ \$MSYSTEM = \"$MSYSTEM\" ] && echo $sh: OK"
    echo "Testing $sh: INTERACTIVE"
    "$sh" -ic "[ \$MSYSTEM = \"$MSYSTEM\" ] && echo $sh: OK"
    echo "Testing $sh: NONE"
    "$sh" -c "[ \$MSYSTEM = \"$MSYSTEM\" ] && echo $sh: OK"
done
