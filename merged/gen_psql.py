import numpy as np
import sys
import pymongo
import json
import gc
import psycopg2


if __name__ == '__main__':
    with open("datafile_2d.json") as f:
        data  = json.load(f)
        query_string = 'INSERT INTO picture(coord, frame, grayscale) VALUES '
        for x in data:
            #coord = x['loc']['coordinates']
            #query_string = f'{query_string}(ST_SetSRID(ST_MakePoint({str(coord[0])},{str(coord[1])}),4326), frm, {str(x["grayscale"])}),'
            coord = x['loc']
            query_string = f'{query_string}(ST_MakePoint({str(coord[0])},{str(coord[1])}), frm, {str(x["grayscale"])}),'

        with open('PSQL_QUERY_STRING', 'w') as f:
            f.write(query_string)

