-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.identities_insert(
	_id uuid,
	_email varchar(250)
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.identities (id, email)
	VALUES (_id, _email);
$$ LANGUAGE SQL;

COMMIT;
