import sys
import math
import json
import asf_search as asf
from datetime import datetime

def get_bbox(latitudes: list[float], longitudes: list[float]) -> tuple:
    # BBOX is defined as S, N, W, E coordinate, each representing the most extreme value.
    return (
        min(latitudes),
        max(latitudes),
        min(longitudes),
        max(longitudes),
    )

def generate_bounding_box(aoi, slcs):
    aoi_coords = aoi['features'][0]['geometry']['coordinates'][0]
    aoi_longitudes = [ coord[0] for coord in aoi_coords ] 
    aoi_latitudes =  [ coord[1] for coord in aoi_coords ]
    aoi_bbox = get_bbox(aoi_latitudes, aoi_longitudes) 

    latitudes, longitudes = [], []
    for slc in slcs:
        coords = slc.geojson()['geometry']['coordinates'][0]
        longitudes += [ coord[0] for coord in coords ]
        latitudes += [ coord[1] for coord in coords ]
    slc_bbox = get_bbox(latitudes, longitudes) 

    return (
        math.floor(max(aoi_bbox[0], slc_bbox[0])), # inverted to get the common region
        math.ceil(min(aoi_bbox[1], slc_bbox[1])),
        math.floor(max(aoi_bbox[2], slc_bbox[2])),
        math.ceil(min(aoi_bbox[3], slc_bbox[3])),
    )

def get_orbit_dates(slcs):
    dates = []
    for slc in slcs:
        date = slc.geojson()['properties']['processingDate']
        date = datetime.fromisoformat(date).strftime('%Y%m%d')
        dates.append(date)
    return dates
        

# get slc data
with open('artifacts/slc/SLC_LIST.txt', 'r') as f:
    slc_list = f.read().replace('\r\n', '').replace('\n', '').split(',')
slcs = asf.product_search(slc_list)

if sys.argv[1] == 'configure':
    # write orbital dates to csv
    dates = get_orbit_dates(slcs)
    with open('artifacts/orbits/dates.csv', 'w') as f:
        f.write('\n'.join(dates))

    # write bounding box dimensions to file
    with open('aoi.geojson', 'r') as f:
        aoi = json.load(f) 

    bbox = generate_bounding_box(aoi, slcs)
    with open('artifacts/dem/bbox', 'w') as f:
        s, n, w, e = bbox
        f.write(f'{s} {n} {w} {e}')

if sys.argv[1] == 'download':
    # download SLC data
    slcs.download('artifacts/slc/', processes=8)
