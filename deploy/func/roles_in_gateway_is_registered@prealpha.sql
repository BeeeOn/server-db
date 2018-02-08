-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_is_registered(
	_gateway_id bigint
)
RETURNS boolean AS
$$
DECLARE
	result boolean;
BEGIN
	SELECT COUNT(*) > 0
	INTO result
	FROM beeeon.roles_in_gateway
	WHERE
		gateway_id = _gateway_id;

	RETURN result;
END;
$$ LANGUAGE plpgsql;

COMMIT;
