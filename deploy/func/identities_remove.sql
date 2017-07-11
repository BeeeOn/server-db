-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.identities_remove(
	_id uuid
)
RETURNS VOID AS
$$
	DELETE FROM beeeon.identities WHERE id = _id;
$$ LANGUAGE SQL;

COMMIT;
