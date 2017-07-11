-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.identities_by_email (
	_email varchar(250)
)
RETURNS SETOF beeeon.identity AS
$$
BEGIN
	RETURN QUERY
		SELECT id, email FROM beeeon.identities
		WHERE email = _email
		LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMIT;
