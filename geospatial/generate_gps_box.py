import random
import sys

lat_distance = 180/float(1000-1) # latitude per pixel height
lon_distance = 360/float(1000-1) # longitude per pixel width

bot_x = random.randrange(0,1000)
bot_y = random.randrange(0,1000)

top_x = bot_x + ( random.randrange(0,1000) % (1000 - bot_x) )
top_y = bot_y + ( random.randrange(0,1000) % (1000 - bot_y) )

bot_x = float(bot_x*lat_distance) - 90.0
top_x = float(top_x*lat_distance) - 90.0
bot_y = float(bot_y*lon_distance) - 180.0
top_y = float(top_y*lon_distance) - 180.0

if sys.argv[1] == 'mongo':
    pass

elif sys.argv[1] == 'psql':
    ret_str = f"coord::geography,ST_SetSRID(ST_GeogFromText('POLYGON(({bot_y} {bot_x}, {top_y} {bot_x}, {top_y} {top_x}, {bot_y} {top_x}, {bot_y} {bot_x}))'),4326)::geography"
    print(ret_str)
