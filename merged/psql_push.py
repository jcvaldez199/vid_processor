import numpy as np
import sys
import pymongo
import json
import gc
import psycopg2


if __name__ == '__main__':
    frame_max = 101

    with open("PSQL_QUERY_STRING") as f:
        query_string = f.readline()

        conn = psycopg2.connect(dbname="gpstest")
        curs = conn.cursor()



        for cnt in range(1, frame_max):
            commit_string = query_string.replace('frm',str(cnt))
            curs.execute(commit_string[:-1])
            print(cnt)

        conn.commit()
