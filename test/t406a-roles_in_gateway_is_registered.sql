SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('roles_in_gateway_is_registered');

SELECT ok(
	NOT roles_in_gateway_is_registered(1240795450208837),
	'cannot be true as there is no data in roles_in_gateway'
);

SELECT finish();
ROLLBACK;
