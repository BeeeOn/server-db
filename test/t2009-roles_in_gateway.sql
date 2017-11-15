SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(18);

SELECT has_table('roles_in_gateway');
SELECT has_pk('roles_in_gateway');

SELECT has_column('roles_in_gateway', 'id');
SELECT col_type_is('roles_in_gateway', 'id', 'uuid');
SELECT col_is_pk('roles_in_gateway', 'id');

SELECT has_column('roles_in_gateway', 'gateway_id');
SELECT col_type_is('roles_in_gateway', 'gateway_id', 'bigint');
SELECT col_is_fk('roles_in_gateway', 'gateway_id');

SELECT has_column('roles_in_gateway', 'identity_id');
SELECT col_type_is('roles_in_gateway', 'identity_id', 'uuid');
SELECT col_is_fk('roles_in_gateway', 'identity_id');

SELECT col_is_unique('roles_in_gateway', ARRAY['gateway_id', 'identity_id']);
SELECT col_is_unique('roles_in_gateway', ARRAY['gateway_id', 'created']);

SELECT has_column('roles_in_gateway', 'level');
SELECT col_type_is('roles_in_gateway', 'level', 'smallint');
SELECT col_has_check('roles_in_gateway', 'level');

SELECT has_column('roles_in_gateway', 'created');
SELECT col_type_is('roles_in_gateway', 'created', 'timestamp without time zone');

SELECT finish();
ROLLBACK;
