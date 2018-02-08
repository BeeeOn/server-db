-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'roles_in_gateway_can_see_verified_identity(uuid, uuid)'
);

ROLLBACK;
