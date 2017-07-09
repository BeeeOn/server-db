-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.gateways_update (
	_id bigint,
	_name varchar(250),
	_altitude integer,
	_latitude double precision,
	_longitude double precision
)
RETURNS BOOLEAN AS
$$
BEGIN
	UPDATE beeeon.gateways
	SET
		name = _name,
		altitude = _altitude,
		latitude = _latitude,
		longitude = _longitude
	WHERE id = _id;

	RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

COMMIT;
