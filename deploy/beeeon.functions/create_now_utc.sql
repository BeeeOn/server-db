-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.now_utc()
RETURNS timestamp AS
$$
	SELECT NOW() AT TIME ZONE 'UTC';
$$ STABLE LANGUAGE SQL;

COMMIT;
