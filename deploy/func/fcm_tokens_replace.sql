-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.fcm_tokens_replace(
	_token_from varchar(250),
	_token_to varchar(250)
)
RETURNS boolean AS
$$
BEGIN
	INSERT INTO fcm_tokens
	SELECT _token_to, user_id
	FROM fcm_tokens
	WHERE
		token = _token_from;

	DELETE FROM fcm_tokens
	WHERE
		token = _token_from;

	RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

COMMIT;
