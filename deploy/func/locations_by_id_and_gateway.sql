-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.locations_by_id_and_gateway(
	_id uuid,
	_gateway_id bigint
)
RETURNS SETOF beeeon.location AS
$$
BEGIN
	RETURN QUERY
		SELECT id, name, gateway_id
		FROM beeeon.locations
		WHERE
			id = _id
			AND
			gateway_id = _gateway_id
		LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMIT;
