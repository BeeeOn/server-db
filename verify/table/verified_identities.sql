-- beeeon-server, pg

BEGIN;

SELECT
	id,
	identity_id,
	user_id,
	provider,
	picture,
	access_token
FROM beeeon.verified_identities
WHERE FALSE;

ROLLBACK;
