-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.locations_update(
	_id uuid,
	_name varchar(250)
)
RETURNS boolean AS
$$
BEGIN
	UPDATE beeeon.locations
	SET
		name = _name
	WHERE
		id = _id;

	RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

COMMIT;
