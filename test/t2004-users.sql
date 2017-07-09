SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(9);

SELECT has_table('users');
SELECT has_pk('users');

SELECT has_column('users', 'id');
SELECT col_type_is('users', 'id', 'uuid');
SELECT col_is_pk('users', 'id');

SELECT has_column('users', 'first_name');
SELECT col_type_is('users', 'first_name', 'character varying(250)');

SELECT has_column('users', 'last_name');
SELECT col_type_is('users', 'last_name', 'character varying(250)');

SELECT finish();
ROLLBACK;
