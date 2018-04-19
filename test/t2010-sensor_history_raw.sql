SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(21);

SELECT has_table('sensor_history_raw');
SELECT has_pk('sensor_history_raw');
SELECT has_fk('sensor_history_raw');

SELECT has_column('sensor_history_raw', 'gateway_id');
SELECT col_type_is('sensor_history_raw', 'gateway_id', 'bigint');
SELECT col_not_null('sensor_history_raw', 'gateway_id');
SELECT col_is_fk('sensor_history_raw', 'gateway_id');

SELECT has_column('sensor_history_raw', 'device_id');
SELECT col_type_is('sensor_history_raw', 'device_id', 'bigint');
SELECT col_not_null('sensor_history_raw', 'device_id');

SELECT col_is_fk('sensor_history_raw', ARRAY['gateway_id', 'device_id']);

SELECT has_column('sensor_history_raw', 'module_id');
SELECT col_type_is('sensor_history_raw', 'module_id', 'smallint');
SELECT col_not_null('sensor_history_raw', 'module_id');

SELECT has_column('sensor_history_raw', 'at');
SELECT col_type_is('sensor_history_raw', 'at', 'timestamp without time zone');
SELECT col_not_null('sensor_history_raw', 'at');

SELECT col_is_pk('sensor_history_raw', ARRAY['gateway_id', 'device_id', 'module_id', 'at']);

SELECT has_column('sensor_history_raw', 'value');
SELECT col_type_is('sensor_history_raw', 'value', 'real');
SELECT col_is_null('sensor_history_raw', 'value');

SELECT finish();
ROLLBACK;
