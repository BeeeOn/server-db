-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.verified_identities_remove(
	_id uuid
)
RETURNS VOID AS
$$
	DELETE FROM beeeon.verified_identities
	WHERE id = _id;
$$ LANGUAGE SQL;

COMMIT;
