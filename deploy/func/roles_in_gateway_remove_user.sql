-- beeeon-server, pg

BEGIN;

-- Delete permissions of the given user for the given gateway.
-- This deletes all roles the user have associated with the
-- gateway via its multiple identities.
CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_remove_user(
	_user_id uuid,
	_gateway_id bigint
)
RETURNS VOID AS
$$
	DELETE FROM beeeon.roles_in_gateway
	WHERE
		identity_id IN
			(SELECT identity_id FROM beeeon.verified_identities
			WHERE
				user_id = _user_id)
		AND
		gateway_id = _gateway_id;
$$ LANGUAGE SQL;

COMMIT;
