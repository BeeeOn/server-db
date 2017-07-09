-- beeeon-server, pg

BEGIN;

SELECT device_id, gateway_id, key, value, params
	FROM beeeon.device_properties WHERE FALSE;

ROLLBACK;
