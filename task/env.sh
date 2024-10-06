#!/usr/bin/env bash

export ISCE_ROOT="$HOME/projects/isce2"

export ISCE_BUILD_PATH="$ISCE_ROOT/build"

export ISCE_BASE_PKG_PATH="$ISCE_BUILD_PATH/packages"
export ISCE_BASE_APP_PATH="$ISCE_BUILD_PATH/packages/isce2/applications"

export ISCE_STCK_PKG_PATH="$ISCE_ROOT/contrib/stack"
export ISCE_STCK_APP_PATH="$ISCE_STCK_PKG_PATH/topsStack"

export PYTHONPATH="$ISCE_BASE_PKG_PATH:$ISCE_STCK_PKG_PATH:$PYTHONPATH"
export PATH="$ISCE_BASE_APP_PATH:$ISCE_STCK_APP_PATH:$PATH"
