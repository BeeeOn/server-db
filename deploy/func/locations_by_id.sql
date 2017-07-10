-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.locations_by_id(
	_id uuid
)
RETURNS SETOF beeeon.location AS
$$
BEGIN

	RETURN QUERY
		SELECT id, name, gateway_id
		FROM beeeon.locations
		WHERE
			id = _id
		LIMIT 1;

END;
$$ LANGUAGE plpgsql;

COMMIT;
