-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'users_by_id(uuid)'
);

ROLLBACK;
