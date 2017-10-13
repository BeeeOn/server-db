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

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.verified_identities',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
