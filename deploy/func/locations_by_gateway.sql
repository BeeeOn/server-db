-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.locations_by_gateway(
	_gateway_id bigint
)
RETURNS SETOF beeeon.location AS
$$
BEGIN
	RETURN QUERY
		SELECT id, name, gateway_id
		FROM beeeon.locations
		WHERE
			gateway_id = _gateway_id;
END;
$$ LANGUAGE plpgsql;

COMMIT;
