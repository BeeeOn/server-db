-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.gateways_insert (
	_id bigint,
	_name varchar(250),
	_altitude integer,
	_latitude double precision,
	_longitude double precision,
	_timezone varchar(64)
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.gateways (
		id,
		name,
		altitude,
		latitude,
		longitude,
		timezone
	)
	VALUES (_id, _name, _altitude, _latitude, _longitude, _timezone);
$$ LANGUAGE SQL;

COMMIT;
