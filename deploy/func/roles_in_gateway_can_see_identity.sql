-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_can_see_identity(
	_identity_id uuid,
	_user_id uuid
)
RETURNS boolean AS
$$
BEGIN
	IF EXISTS (
		SELECT
			v.id
		FROM beeeon.verified_identities AS v
		WHERE
			v.user_id = _user_id
			AND
			v.identity_id = _identity_id
	) THEN
		-- can see herself
		RETURN true;
	ELSIF EXISTS (
		SELECT
			r.id
		FROM beeeon.roles_in_gateway AS r
		JOIN beeeon.users_of_gateway AS u
			ON u.gateway_id = r.gateway_id
		WHERE
			r.identity_id = _identity_id
			AND
			u.user_id = _user_id
	) THEN
		-- can see the identity
		RETURN true;
	ELSE
		RETURN false;
	END IF;
END;
$$ LANGUAGE plpgsql;

COMMIT;
