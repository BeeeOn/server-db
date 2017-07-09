-- beeeon-server, pg

BEGIN;

SELECT id, name, gateway_id
	FROM beeeon.locations WHERE FALSE;

ROLLBACK;
