import sys
import math
import json
import asf_search as asf
from datetime import datetime


def get_bounding_box(aoi, slcs):
    aoi_coords = aoi['features'][0]['geometry']['coordinates'][0]
    aoi_longitudes = [ point[0] for point in aoi_coords ] 
    aoi_latitudes =  [ point[1] for point in aoi_coords ]

    aoi_bbox = (
        math.floor(min(aoi_latitudes)), 
        math.ceil(max(aoi_latitudes)), 
        math.floor(min(aoi_longitudes)), 
        math.ceil(max(aoi_longitudes)),
    )

    longitudes = []
    latitudes = []
    for slc in slcs:
        coords = slc.geojson()['geometry']['coordinates'][0]
        longitudes += [ point[0] for point in coords ]
        latitudes += [ point[1] for point in coords ]

    bbox = (
        math.floor(min(latitudes)), 
        math.ceil(max(latitudes)), 
        math.floor(min(longitudes)), 
        math.ceil(max(longitudes)),
    )

    return (
        max(aoi_bbox[0], bbox[0]),
        min(aoi_bbox[1], bbox[1]),
        max(aoi_bbox[2], bbox[2]),
        min(aoi_bbox[3], bbox[3]),
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

    bbox = get_bounding_box(aoi, slcs)
    with open('artifacts/dem/bbox', 'w') as f:
        s, n, w, e = bbox
        f.write(f'{s} {n} {w} {e}')

if sys.argv[1] == 'download':
    # download SLC data
    slcs.download('artifacts/slc/', processes=8)
