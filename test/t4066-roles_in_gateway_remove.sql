SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('roles_in_gateway_remove');

SELECT lives_ok(
	$$ SELECT roles_in_gateway_remove('35a6c2ce-27a4-4d24-b787-3d6c8ac0877a') $$,
	'removing of non-existing role should not fail'
);

SELECT finish();
ROLLBACK;
