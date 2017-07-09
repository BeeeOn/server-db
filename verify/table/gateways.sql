-- beeeon-server, pg

BEGIN;

SELECT id, name, altitude, latitude, longitude
	FROM beeeon.gateways WHERE FALSE;

ROLLBACK;
