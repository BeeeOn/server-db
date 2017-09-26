-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.fcm_tokens_remove(
	_token varchar(250)
)
RETURNS VOID AS
$$
	DELETE FROM beeeon.fcm_tokens WHERE token = _token;
$$ LANGUAGE SQL;

COMMIT;
