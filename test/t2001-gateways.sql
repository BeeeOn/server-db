SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(20);

SELECT has_table('gateways');
SELECT has_pk('gateways');

SELECT has_column('gateways', 'id');
SELECT col_type_is('gateways', 'id', 'bigint');
SELECT col_is_pk('gateways', 'id');

SELECT has_column('gateways', 'name');
SELECT col_type_is('gateways', 'name', 'character varying(250)');
SELECT col_not_null('gateways', 'name');

SELECT has_column('gateways', 'altitude');
SELECT col_type_is('gateways', 'altitude', 'integer');
SELECT col_is_null('gateways', 'altitude');

SELECT has_column('gateways', 'latitude');
SELECT col_type_is('gateways', 'latitude', 'double precision');
SELECT col_is_null('gateways', 'latitude');

SELECT has_column('gateways', 'longitude');
SELECT col_type_is('gateways', 'longitude', 'double precision');
SELECT col_is_null('gateways', 'longitude');

SELECT has_column('gateways', 'timezone');
SELECT col_type_is('gateways', 'timezone', 'character varying(64)');
SELECT col_not_null('gateways', 'timezone');

SELECT finish();
ROLLBACK;
