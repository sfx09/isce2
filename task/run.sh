#!/usr/bin/env bash

# automagically get the ISCE root path
SCRIPT_DIR=$(dirname "$(realpath "$0")")
ISCE_ROOT=$(dirname "$SCRIPT_DIR")
export ISCE_ROOT

export ISCE_BUILD_PATH="$ISCE_ROOT/build"

export ISCE_BASE_PKG_PATH="$ISCE_BUILD_PATH/packages"
export ISCE_BASE_APP_PATH="$ISCE_BUILD_PATH/packages/isce2/applications"

export ISCE_STCK_PKG_PATH="$ISCE_ROOT/contrib/stack"
export ISCE_STCK_APP_PATH="$ISCE_STCK_PKG_PATH/topsStack"

export PYTHONPATH="$ISCE_BASE_PKG_PATH:$ISCE_STCK_PKG_PATH:$PYTHONPATH"
export PATH="$ISCE_BASE_APP_PATH:$ISCE_STCK_APP_PATH:$PATH"

SLC_LINK="https://korraicom-my.sharepoint.com/:t:/g/personal/rahul_korrai_com/EbnUgoKGx51JjfFA9Q9N6UwB9bowJox52oPs1AgUVh8Fzg?download=1"
AUX_LINK="https://sar-mpc.eu/download/ca97845e-1314-4817-91d8-f39afbeff74d/"
AUX_FILE="S1A_AUX_CAL_V20140908T000000_G20190626T100201.SAFE.zip"

function init {
  apt-get update
  xargs apt-get install -y < pkglist

}

function build {
  mkdir -p "$ISCE_BUILD_PATH"
  (
    cd "$ISCE_BUILD_PATH" || exit 
    cmake .. -DCMAKE_INSTALL_PREFIX="$ISCE_BUILD_PATH"
    make install
  )
}

function clean {
  rm -rf "$ISCE_BUILD_PATH"
}

function get_slc_list {
  wget "$SLC_LINK" -O artifacts/slc/SLC_LIST.txt
} 

function get_slc_metadata {
  python3 slc.py configure
}

function get_slc_data {
  python3 slc.py download
}

function get_orbit_data {
  (
    cd artifacts/orbits || exit
    cat dates | xargs -I {} mkdir {} && dloadOrbit.py -b {} -e {} -d {}
  )
}

function get_aux_data {
  wget "$AUX_LINK" -O "artifacts/$AUX_FILE"
}

function get_dem_data {
  (
    cd artifacts/dem || exit
    cat bbox | xargs -I {} dem.py -a stitch -b {}
  )
}

function get_run_scripts {
  (
    DEM_FILE=$(find . -iname '*.dem.wgs84' | tail -n 1)
    cd artifacts || exit
    stackSentinel.py -d "$DEM_FILE" -s slc -a aux -o orbits -W slc
  )
}

