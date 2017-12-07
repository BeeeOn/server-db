-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.as_utc_timestamp_us(unix bigint)
RETURNS TIMESTAMP AS
$$
DECLARE
	frac_sec double precision;
BEGIN
	-- extract fractional parts of seconds (i.e. ms and us)
	frac_sec := (unix % 1000000)::double precision / 1000000;

	RETURN beeeon.as_utc_timestamp(unix / 1000000)
		+ make_interval(0, 0, 0, 0, 0, 0, frac_sec);
END;
$$ LANGUAGE plpgsql;

COMMIT;
