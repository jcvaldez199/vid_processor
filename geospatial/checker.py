import numpy as np
import sys
import pymongo
import json
import gc
import psycopg2


if __name__ == '__main__':
    frame_max = 101
    frame_max = 11

    with open("datafile.json") as f:
        data  = json.load(f)

        conn = psycopg2.connect(dbname="gpstest")
        curs = conn.cursor()

        query_string = 'INSERT INTO picture(coord, frame, grayscale) VALUES '
        for x in data:
            coord = x['loc']['coordinates']
            #query_string = query_string+'(ST_SetSRID(ST_MakePoint('+str(coord[0])+','+str(coord[1])+'),4326), frm, '+str(x["grayscale"])+'),'
            query_string = f'{query_string}(ST_SetSRID(ST_MakePoint({str(coord[0])},{str(coord[1])}),4326), frm, {str(x["grayscale"])}),'

        for cnt in range(1, frame_max):
            commit_string = query_string.replace('frm',str(cnt))
            curs.execute(commit_string[:-1])
            print(cnt)

        conn.commit()
