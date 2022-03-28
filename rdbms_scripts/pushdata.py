import numpy as np
import sys
import pymongo
import json
import gc
import psycopg2


if __name__ == '__main__':
    frame_max = 11

    with open("datafile.json") as f:
        data  = json.load(f)

        conn = psycopg2.connect(dbname="gpstest")
        curs = conn.cursor()

        query_string = 'INSERT INTO picture(coord, frame, grayscale) VALUES '
        for x in data:
            query_string = query_string+'(ST_MakePoint('+str(x["loc"][0])+','+str(x["loc"][1])+'), frm, '+str(x["grayscale"])+'),'

        for cnt in range(1, frame_max):
            commit_string = query_string.replace('frm',str(cnt))
            curs.execute(commit_string[:-1])
            print(cnt)

        conn.commit()
