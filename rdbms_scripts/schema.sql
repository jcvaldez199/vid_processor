DROP TABLE IF EXISTS picture;
CREATE EXTENSION IF NOT EXISTS plpgsql;
CREATE EXTENSION postgis;

CREATE TABLE picture (
  coord geometry,
  frame INTEGER, 
  grayscale INTEGER, 
  PRIMARY KEY (coord, frame)
);

