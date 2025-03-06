#!/bin/bash

set -e

(cd ./path_convert_integration && ./test.sh)
(cd ./path_convert && ./test.sh)
(cd ./symlinks && ./test.sh)

./custom.sh
