-- beeeon-server, pg

BEGIN;

SELECT
	gateway_id,
	device_id,
	module_id,
	value,
	at,
	stability,
	originator_user_id
FROM beeeon.controls_recent WHERE FALSE;

ROLLBACK;
