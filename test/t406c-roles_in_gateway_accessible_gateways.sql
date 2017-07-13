SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('roles_in_gateway_accessible_gateways');

SELECT is_empty(
	$$ SELECT * FROM roles_in_gateway_accessible_gateways(10, 'b6c168de-32c0-45a9-b23e-c936ac217ef1') $$,
	'there is nothing yet in the roles_in_gateway table'
);

SELECT finish();
ROLLBACK;
