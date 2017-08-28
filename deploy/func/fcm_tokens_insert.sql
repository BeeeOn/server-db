-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.fcm_tokens_insert(
	_token varchar(250),
	_user_id uuid
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.fcm_tokens (token, user_id)
	VALUES (_token, _user_id);
$$ LANGUAGE SQL;

COMMIT;
