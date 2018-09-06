-- beeeon-server, pg

BEGIN;

SELECT
	id,
	name,
	altitude,
	latitude,
	longitude,
	timezone,
	roles_count,
	devices_count,
	owner_id
FROM beeeon.legacy_gateways
WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.legacy_gateways',
	ARRAY['select']
);

ROLLBACK;
