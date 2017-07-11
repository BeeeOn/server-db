-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.verified_identities_insert(
	_id uuid,
	_identity_id uuid,
	_user_id uuid,
	_provider varchar(250),
	_picture varchar(250),
	_access_token varchar(250)
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.verified_identities (
		id,
		identity_id,
		user_id,
		provider,
		picture,
		access_token
	)
	VALUES (
		_id,
		_identity_id,
		_user_id,
		_provider,
		_picture,
		_access_token
	);
$$ LANGUAGE SQL;

COMMIT;
