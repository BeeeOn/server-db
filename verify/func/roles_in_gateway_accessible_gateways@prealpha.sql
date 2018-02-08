-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'roles_in_gateway_accessible_gateways(integer, uuid)'
);

ROLLBACK;
