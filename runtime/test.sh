#!/bin/bash

set -e

(cd ./path_convert_integration && ./test.sh)
(cd ./path_convert && ./test.sh)

./custom.sh
