#!/usr/bin/env bash

set -e 

source env.sh

mkdir -p artifacts/{dem,slc,orbits,aux}

# download SLC files
SLC_LINK="https://korraicom-my.sharepoint.com/:t:/g/personal/rahul_korrai_com/EbnUgoKGx51JjfFA9Q9N6UwB9bowJox52oPs1AgUVh8Fzg?download=1"
wget "$SLC_LINK" -O artifacts/slc/SLC_LIST.txt
python3 slc.py

cd artifacts

# download orbit files might not be required, since stackSentinal re-fetches these values
dloadOrbits.py -d orbits

# downloading AUX files might not be required, since SLCs are dated after 2015. (no error-correction needed)
AUX_LINK="https://sar-mpc.eu/download/ca97845e-1314-4817-91d8-f39afbeff74d/"
wget "$AUX_LINK" -O aux/S1A_AUX_CAL_V20140908T000000_G20190626T100201.SAFE.zip

# download DEM
cd dem
dem.py -a stitch -b 44 47 -65 -61 -c
cd ..

# run the script
stackSentinel.py -d dem/demLat_N44_N47_Lon_W065_W061.dem.wgs84 -s slc -a aux -o orbits -W slc
