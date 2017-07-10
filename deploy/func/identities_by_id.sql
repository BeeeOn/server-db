-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.identities_by_id(
	_id uuid
)
RETURNS SETOF beeeon.identity AS
$$
BEGIN
	RETURN QUERY
		SELECT * FROM beeeon.identities
		WHERE id = _id;
END;
$$ LANGUAGE plpgsql;

COMMIT;
