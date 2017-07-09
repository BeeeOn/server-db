-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.gateways_insert (
	_id bigint,
	_name varchar(250),
	_altitude integer,
	_latitude double precision,
	_longitude double precision
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.gateways (
		id,
		name,
		altitude,
		latitude,
		longitude
	)
	VALUES (_id, _name, _altitude, _latitude, _longitude);
$$ LANGUAGE SQL;

COMMIT;
