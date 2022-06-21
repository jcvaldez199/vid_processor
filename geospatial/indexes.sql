CREATE INDEX spatial_index ON picture USING GIST ( coord );
CREATE INDEX sequent_index ON picture USING BTREE ( frame );
CREATE INDEX geog_cast ON picture USING GIST ( geography(coord) );

--CREATE INDEX seqcoord_index ON picture USING BTREE ( coord );
