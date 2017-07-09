SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(15);

SELECT has_table('device_properties');
SELECT has_pk('device_properties');

SELECT has_column('device_properties', 'device_id');
SELECT col_type_is('device_properties', 'device_id', 'bigint');

SELECT has_column('device_properties', 'gateway_id');
SELECT col_type_is('device_properties', 'gateway_id', 'bigint');
SELECT col_is_fk('device_properties', 'gateway_id');

SELECT col_is_fk('device_properties', ARRAY['gateway_id', 'device_id']);

SELECT has_column('device_properties', 'key');
SELECT col_type_is('device_properties', 'key', 'smallint');

SELECT col_is_pk('device_properties', ARRAY['gateway_id', 'device_id', 'key']);

SELECT has_column('device_properties', 'value');
SELECT col_type_is('device_properties', 'value', 'text');

SELECT has_column('device_properties', 'params');
SELECT col_type_is('device_properties', 'params', 'text');

SELECT finish();
ROLLBACK;
