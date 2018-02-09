-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'roles_in_gateway_is_user(uuid, uuid)'
);

ROLLBACK;
