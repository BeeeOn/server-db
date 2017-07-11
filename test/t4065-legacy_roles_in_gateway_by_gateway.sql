SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('legacy_roles_in_gateway_by_gateway');

SELECT is_empty(
	$$ SELECT * FROM legacy_roles_in_gateway_by_gateway(1240795450208837) $$,
	'there is nothing yet in the roles_in_gateway table'
);

SELECT finish();
ROLLBACK;
