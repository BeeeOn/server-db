-- beeeon-server pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'roles_in_gateway_insert(uuid, bigint, uuid, integer, bigint)'
);

ROLLBACK;
