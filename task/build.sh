#!/usr/bin/env bash

source env.sh

mkdir -p "$ISCE_BUILD_PATH"
cd "$ISCE_BUILD_PATH" 

cmake .. -DCMAKE_INSTALL_PREFIX="$ISCE_BUILD_PATH"
make install
