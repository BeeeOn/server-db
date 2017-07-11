-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_remove(
	_id uuid	
)
RETURNS VOID AS
$$
	DELETE FROM beeeon.roles_in_gateway WHERE id = _id;
$$ LANGUAGE SQL;

COMMIT;
