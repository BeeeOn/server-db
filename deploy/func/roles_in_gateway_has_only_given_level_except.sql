-- beeeon-server, pg

BEGIN;

---
-- Tell whether the there are users other then the given user (_user_id)
-- who have the permission level higher then the given level.
--
-- Use case:
--   Are there any guest users other then me?
---
CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_has_only_given_level_except(
	_level integer,
	_gateway_id bigint,
	_user_id uuid
)
RETURNS boolean AS
$$
DECLARE
	result boolean;
BEGIN
	SELECT COUNT(*) > 0
	INTO result
	FROM beeeon.roles_in_gateway
	WHERE
		level > _level
		AND
		gateway_id = _gateway_id
		AND
		identity_id NOT IN
		(SELECT identity_id
			FROM beeeon.verified_identities
			WHERE user_id = _user_id);

	RETURN result;
END;
$$ LANGUAGE plpgsql;

COMMIT;
