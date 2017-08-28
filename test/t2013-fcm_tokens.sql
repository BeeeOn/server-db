SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(8);

SELECT has_table('fcm_tokens');
SELECT has_pk('fcm_tokens');

SELECT has_column('fcm_tokens', 'token');
SELECT col_type_is('fcm_tokens', 'token', 'character varying(250)');
SELECT col_is_pk('fcm_tokens', 'token');

SELECT has_column('fcm_tokens', 'user_id');
SELECT col_type_is('fcm_tokens', 'user_id', 'uuid');
SELECT col_is_fk('fcm_tokens', 'user_id');

SELECT finish();
ROLLBACK;
