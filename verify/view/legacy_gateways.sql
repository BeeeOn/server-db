-- beeeon-server, pg

BEGIN;

SELECT
	id,
	name,
	altitude,
	latitude,
	longitude,
	roles_count,
	devices_count,
	owner_id
FROM beeeon.legacy_gateways
WHERE FALSE;

ROLLBACK;
