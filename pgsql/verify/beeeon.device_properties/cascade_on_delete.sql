-- beeeon-server, pg

BEGIN;

SELECT 1 / COUNT(*)
	FROM pg_catalog.pg_constraint
	JOIN pg_catalog.pg_namespace n
		ON n.oid = connamespace
	WHERE
		n.nspname = 'beeeon'
		AND
		conname = 'device_properties_devices_fk'
		AND
		confdeltype = 'c';

ROLLBACK;
