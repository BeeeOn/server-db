-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.as_utc_timestamp_us(unix bigint)
RETURNS TIMESTAMP AS
$$
DECLARE
	us double precision;
BEGIN
	-- extract fractional parts of seconds (i.e. ms and us)
	us := (unix % 1000000)::double precision;

	RETURN beeeon.as_utc_timestamp(unix / 1000000)
		+ us * interval '1 microseconds';
END;
$$ LANGUAGE plpgsql;

COMMIT;
