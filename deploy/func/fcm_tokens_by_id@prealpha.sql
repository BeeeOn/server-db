-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.fcm_tokens_by_id(
	_token varchar(250)
)
RETURNS SETOF beeeon.fcm_token AS
$$
BEGIN
	RETURN QUERY
		SELECT
			t.token,
			u.id,
			u.first_name,
			u.last_name,
			u.locale
		FROM beeeon.fcm_tokens AS t
		JOIN beeeon.users AS u
			ON t.user_id = u.id
		WHERE
			t.token = _token
		LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMIT;
