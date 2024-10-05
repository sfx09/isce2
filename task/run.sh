#!/usr/bin/env bash

source env.sh
source .venv/bin/activate

set -e 

# download SLC files
python3 slc.py

# download orbit files
dloadOrbits.py

# download DEM
dem.py -a stitch -b '18 20 -100 -97' -r -s 1 -c -d artifacts/dem

# download AUX files


# run the script
# stackSentinel.py -s artifacts/slc -d artifacts/dem/demLat_N18_N20_Lon_W100_W097.dem.wgs84 -b '19 20 -99.5 -98.5' -a artifacts/aux -o artifacts/orbits -C NESD -W slc

