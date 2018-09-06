-- beeeon-server, pg

BEGIN;

SELECT gateway_id, at, version, ip
	FROM beeeon.gateways_status WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.gateways_status',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
