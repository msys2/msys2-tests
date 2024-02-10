#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

# This breaks if relocation is broken and gettext can't find the .its files
# "warning: file 'test.appdata.xml' extension 'xml' is unknown; will try C"
xgettext --from-code=UTF-8 -o /dev/null test.appdata.xml
