import shapefile
from osgeo import ogr
import argparse
import shapely
from shapely.geometry import Polygon
from shapely.geometry import shape
from shapely.geometry import MultiPolygon
from pyproj import Proj
import numpy as np
import os

parser = argparse.ArgumentParser()
parser.add_argument('--input', help='input gmt file')

args = parser.parse_args()


def area(data):

    lo=data[:,0]
    la=data[:,1]

    pa = Proj("+proj=stere +lat_0=90.0 +lat_ts=70 +lon_0=-45")

    x, y = pa(lo, la)
    cop = {"type": "Polygon", "coordinates": [zip(x, y)]}
    b = shape(cop)
    return b.area

if __name__=='__main__':
    input_data = np.loadtxt(args.input)
    area_data=area(input_data)
    print(area_data)