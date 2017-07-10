-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.users_by_id(
	_id uuid
)
RETURNS SETOF beeeon.user AS
$$
BEGIN
	RETURN QUERY
		SELECT id, first_name, last_name, locale
		FROM beeeon.users
		WHERE
			id = _id
		LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMIT;
