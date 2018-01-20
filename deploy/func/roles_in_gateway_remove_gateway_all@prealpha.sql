-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_remove_gateway_all(
	_gateway_id bigint
)
RETURNS VOID AS
$$
	DELETE FROM beeeon.roles_in_gateway
	WHERE gateway_id = _gateway_id;
$$ LANGUAGE SQL;

COMMIT;
