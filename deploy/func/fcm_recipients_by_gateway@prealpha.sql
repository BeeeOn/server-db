-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.fcm_recipients_by_gateway(
	_gateway_id BIGINT
)
RETURNS SETOF beeeon.fcm_token AS
$$
BEGIN
	RETURN QUERY
		SELECT
			t.token,
			t.user_id,
			u.first_name,
			u.last_name,
			u.locale
		FROM beeeon.fcm_tokens AS t
		JOIN beeeon.verified_identities AS v
			ON t.user_id = v.user_id
		JOIN beeeon.roles_in_gateway AS r
			ON r.identity_id = v.identity_id
		JOIN beeeon.users AS u
			ON u.id = t.user_id
		WHERE
			r.gateway_id = _gateway_id;
END;
$$ LANGUAGE plpgsql;

COMMIT;
