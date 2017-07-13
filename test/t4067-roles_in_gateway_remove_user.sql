SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('roles_in_gateway_remove_user');

SELECT lives_ok(
	$$ SELECT roles_in_gateway_remove_user('83f42cf5-16e3-4fcb-b4f7-4426e738c779', 1537405487422784) $$,
	'there is no reason to fail on removing non-existing roles'
);

SELECT finish();
ROLLBACK;
