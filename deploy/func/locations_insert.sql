-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.locations_insert(
	_id uuid,
	_name varchar(250),
	_gateway_id bigint
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.locations (id, name, gateway_id)
	VALUES (_id, _name, _gateway_id);
$$ LANGUAGE SQL;

COMMIT;
