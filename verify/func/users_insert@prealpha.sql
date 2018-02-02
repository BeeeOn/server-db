-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'users_insert(uuid, varchar(250), varchar(250), varchar(32))'
);

ROLLBACK;
