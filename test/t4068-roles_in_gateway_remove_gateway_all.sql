SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('roles_in_gateway_remove_gateway_all');

SELECT lives_ok(
	$$ SELECT roles_in_gateway_remove_gateway_all(1240795450208837) $$,
	'removing of non-existing role via a non-existing gateway should not fail'
);

SELECT finish();
ROLLBACK;
