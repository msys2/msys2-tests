#!/bin/bash

set -e

(cd ./test-libc++-static && ./test.sh)
(cd test-cc-stack-size && ./test.sh)
(cd test-delayload && ./test.sh)
(cd test-reproducible && ./test.sh)
