-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_update(
	_id uuid,
	_level smallint
)
RETURNS BOOLEAN AS
$$
BEGIN
	UPDATE beeeon.roles_in_gateway
	SET
		level = _level
	WHERE
		id = _id;

	RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

COMMIT;
