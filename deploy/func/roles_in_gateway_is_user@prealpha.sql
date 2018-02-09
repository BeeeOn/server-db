-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_is_user(
	_role_id uuid,
	_user_id uuid
)
RETURNS boolean AS
$$
DECLARE
	result boolean;
BEGIN
	SELECT COUNT(*) > 0
	INTO result
	FROM beeeon.roles_in_gateway AS r
	JOIN beeeon.verified_identities AS v
		ON r.identity_id = v.identity_id
	JOIN beeeon.users AS u
		ON u.id = v.user_id
	WHERE
		r.id = _role_id
		AND
		u.id = _user_id;

	RETURN result;
END;
$$ LANGUAGE plpgsql;

COMMIT;
