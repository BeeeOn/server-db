-- beeeon-server, pg

BEGIN;

SELECT
	token,
	user_id
FROM beeeon.fcm_tokens
WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.fcm_tokens',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
