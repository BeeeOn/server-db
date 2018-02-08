-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'roles_in_gateway_has_only_given_level_except(integer, bigint, uuid)'
);

ROLLBACK;
