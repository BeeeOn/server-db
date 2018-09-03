-- beeeon-server, pg

BEGIN;

SELECT
	id,
	gateway_id,
	location_id,
	name,
	type,
	refresh,
	battery,
	signal,
	first_seen,
	last_seen,
	active_since
FROM beeeon.devices
WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.devices',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
