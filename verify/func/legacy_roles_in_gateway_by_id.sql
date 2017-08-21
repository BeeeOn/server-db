-- beeeon-server pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'legacy_roles_in_gateway_by_id(uuid)'
);

ROLLBACK;
