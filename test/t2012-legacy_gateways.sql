SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(17);

SELECT has_view('legacy_gateways');

SELECT has_column('legacy_gateways', 'id');
SELECT col_type_is('legacy_gateways', 'id', 'bigint');

SELECT has_column('legacy_gateways', 'name');
SELECT col_type_is('legacy_gateways', 'name', 'character varying(250)');

SELECT has_column('legacy_gateways', 'altitude');
SELECT col_type_is('legacy_gateways', 'altitude', 'integer');

SELECT has_column('legacy_gateways', 'latitude');
SELECT col_type_is('legacy_gateways', 'latitude', 'double precision');

SELECT has_column('legacy_gateways', 'longitude');
SELECT col_type_is('legacy_gateways', 'longitude', 'double precision');

SELECT has_column('legacy_gateways', 'roles_count');
SELECT col_type_is('legacy_gateways', 'roles_count', 'bigint');

SELECT has_column('legacy_gateways', 'devices_count');
SELECT col_type_is('legacy_gateways', 'devices_count', 'bigint');

SELECT has_column('legacy_gateways', 'owner_id');
SELECT col_type_is('legacy_gateways', 'owner_id', 'uuid');

SELECT finish();
ROLLBACK;
