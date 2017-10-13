-- beeeon-server, pg

BEGIN;

SELECT id, name, altitude, latitude, longitude
	FROM beeeon.gateways WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.gateways',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
