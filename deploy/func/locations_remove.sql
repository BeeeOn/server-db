-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.locations_remove(
	_id uuid
)
RETURNS VOID AS
$$
	DELETE FROM beeeon.locations WHERE id = _id;
$$ LANGUAGE SQL;

COMMIT;
