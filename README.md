1. set preamble parameters
2. run preamble
3. add geospatial index 
db.imagetest_normal.createIndex( { "loc" : "2d", "loc.0" : 1, "frame" : 1 } , { min : 0 , max :  640 } )
4. set profiling on db.setProfilingLevel(2) # this somewhat excludes above 100 for some reason... remove that
5. fix crop_test collection name
6. run crop_test



POSTGIS BOX QUERIES
ST_ContainsProperly
ST_CoveredBy
ST_Contains
ST_Covers
ST_Within

POSTGIS SPHERICAL ONLY
ST_DFullyWithin
ST_DWithin

POSTGIS GEOSPATIAL
ST_CoveredBy
ST_Covers
ST_DWithin

