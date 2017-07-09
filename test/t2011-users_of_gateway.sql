SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(11);

SELECT has_view('users_of_gateway');

SELECT has_column('users_of_gateway', 'gateway_id');
SELECT col_type_is('users_of_gateway', 'gateway_id', 'bigint');

SELECT has_column('users_of_gateway', 'role_id');
SELECT col_type_is('users_of_gateway', 'role_id', 'uuid');

SELECT has_column('users_of_gateway', 'created');
SELECT col_type_is('users_of_gateway', 'created', 'timestamp with time zone');

SELECT has_column('users_of_gateway', 'level');
SELECT col_type_is('users_of_gateway', 'level', 'smallint');

SELECT has_column('users_of_gateway', 'user_id');
SELECT col_type_is('users_of_gateway', 'user_id', 'uuid');

SELECT finish();
ROLLBACK;
