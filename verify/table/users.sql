-- beeeon-server, pg

BEGIN;

SELECT id, first_name, last_name
	FROM beeeon.users WHERE FALSE;

ROLLBACK;
