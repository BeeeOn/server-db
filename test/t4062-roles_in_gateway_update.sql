SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('roles_in_gateway_update');

SELECT ok(
	NOT roles_in_gateway_update('83f42cf5-16e3-4fcb-b4f7-4426e738c779', 20::smallint),
	'there is nothing to update'
);

SELECT finish();
ROLLBACK;
