SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(19);

SELECT has_table('verified_identities');
SELECT has_pk('verified_identities');
SELECT has_unique('verified_identities');

SELECT has_column('verified_identities', 'id');
SELECT col_type_is('verified_identities', 'id', 'uuid');
SELECT col_is_pk('verified_identities', 'id');

SELECT has_column('verified_identities', 'identity_id');
SELECT col_type_is('verified_identities', 'identity_id', 'uuid');
SELECT col_is_fk('verified_identities', 'identity_id');

SELECT has_column('verified_identities', 'user_id');
SELECT col_type_is('verified_identities', 'user_id', 'uuid');
SELECT col_is_fk('verified_identities', 'user_id');

SELECT has_column('verified_identities', 'provider');
SELECT col_type_is('verified_identities', 'provider', 'character varying(250)');

SELECT col_is_unique('verified_identities', ARRAY['identity_id', 'provider']);

SELECT has_column('verified_identities', 'picture');
SELECT col_type_is('verified_identities', 'picture', 'character varying(250)');

SELECT has_column('verified_identities', 'access_token');
SELECT col_type_is('verified_identities', 'access_token', 'character varying(250)');

SELECT finish();
ROLLBACK;
