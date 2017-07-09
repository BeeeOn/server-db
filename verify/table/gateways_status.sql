-- beeeon-server, pg

BEGIN;

SELECT gateway_id, at, version, ip
	FROM beeeon.gateways_status WHERE FALSE;

ROLLBACK;
