-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.verified_identities_update(
	_id uuid,
	_picture varchar(250),
	_access_token varchar(250)
)
RETURNS BOOLEAN AS
$$
BEGIN
	UPDATE beeeon.verified_identities
	SET
		picture = _picture,
		access_token = _access_token
	WHERE
		id = _id;

	RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

COMMIT;
