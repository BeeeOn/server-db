-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.fcm_tokens_by_user_id(
	_user_id uuid
)
RETURNS SETOF beeeon.fcm_tokens AS
$$
BEGIN
	RETURN QUERY
		SELECT token, user_id
		FROM beeeon.fcm_tokens
		WHERE
			user_id = _user_id;
END;
$$ LANGUAGE plpgsql;

COMMIT;
