-- beeeon-server, pg

BEGIN;

SELECT
	gateway_id,
	device_id,
	module_id,
	value,
	requested_at,
	accepted_at,
	finished_at,
	failed,
	originator_user_id
FROM beeeon.controls_fsm WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.controls_fsm',
	ARRAY['select', 'insert', 'update', 'delete']
);

SELECT
	gateway_id,
	device_id,
	module_id,
	value,
	requested_at,
	accepted_at,
	finished_at,
	failed,
	originator_user_id
FROM beeeon.controls_fsm_last WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.controls_fsm_last',
	ARRAY['select', 'insert', 'update', 'delete']
);

SELECT beeeon.assure_function(
	'beeeon',
	'controls_fsm_last_update()'
);

ROLLBACK;
