SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(10);

SELECT has_table('locations');
SELECT has_pk('locations');

SELECT has_column('locations', 'id');
SELECT col_type_is('locations', 'id', 'uuid');
SELECT col_is_pk('locations', 'id');

SELECT has_column('locations', 'name');
SELECT col_type_is('locations', 'name', 'character varying(250)');

SELECT has_column('locations', 'gateway_id');
SELECT col_type_is('locations', 'gateway_id', 'bigint');
SELECT col_is_fk('locations', 'gateway_id');

SELECT finish();
ROLLBACK;
