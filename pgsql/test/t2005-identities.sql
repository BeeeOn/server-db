SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(10);

SELECT has_table('identities');
SELECT has_pk('identities');
SELECT has_unique('identities');

SELECT has_column('identities', 'id');
SELECT col_type_is('identities', 'id', 'uuid');
SELECT col_is_pk('identities', 'id');

SELECT has_column('identities', 'email');
SELECT col_type_is('identities', 'email', 'character varying(250)');
SELECT col_is_unique('identities', 'email');
SELECT col_has_check('identities', 'email');

SELECT finish();
ROLLBACK;
