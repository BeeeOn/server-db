SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('roles_in_gateway_has_only_given_level_except');

SELECT ok(
	NOT roles_in_gateway_has_only_given_level_except(0, 1240795450208837, '2b4e6352-0412-45c4-bdd9-d3a1898ed936'),
	'cannot be true as there is no data in roles_in_gateway'
);

SELECT finish();
ROLLBACK;
