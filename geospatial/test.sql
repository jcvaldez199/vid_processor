DO
$do$
DECLARE
   _timing1  timestamptz;
   _start_ts timestamptz;
   _end_ts   timestamptz;
   _overhead numeric;     -- in ms
   _timing   numeric;     -- in ms
BEGIN
   _timing1  := clock_timestamp();
   _start_ts := clock_timestamp();
   _end_ts   := clock_timestamp();
   -- take minimum duration as conservative estimate
   _overhead := 1000 * extract(epoch FROM LEAST(_start_ts - _timing1
                                              , _end_ts   - _start_ts));

   _start_ts := clock_timestamp();
PERFORM grayscale FROM picture WHERE ST_DWithin(coord::geography,ST_SetSRID(ST_MakePoint(-96,-75),4326)::geography, 1365000) AND frame = 100;
   _end_ts   := clock_timestamp();
   
-- RAISE NOTICE 'Timing overhead in ms = %', _overhead;
   RAISE NOTICE '%' , 1000 * (extract(epoch FROM _end_ts - _start_ts)) - _overhead;
END
$do$;
