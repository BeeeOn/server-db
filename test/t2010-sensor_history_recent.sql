SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(21);

SELECT has_table('sensor_history_recent');
SELECT has_pk('sensor_history_recent');
SELECT has_fk('sensor_history_recent');

SELECT has_column('sensor_history_recent', 'gateway_id');
SELECT col_type_is('sensor_history_recent', 'gateway_id', 'bigint');
SELECT col_not_null('sensor_history_recent', 'gateway_id');
SELECT col_is_fk('sensor_history_recent', 'gateway_id');

SELECT has_column('sensor_history_recent', 'device_id');
SELECT col_type_is('sensor_history_recent', 'device_id', 'bigint');
SELECT col_not_null('sensor_history_recent', 'device_id');

SELECT col_is_fk('sensor_history_recent', ARRAY['gateway_id', 'device_id']);

SELECT has_column('sensor_history_recent', 'module_id');
SELECT col_type_is('sensor_history_recent', 'module_id', 'smallint');
SELECT col_not_null('sensor_history_recent', 'module_id');

SELECT has_column('sensor_history_recent', 'at');
SELECT col_type_is('sensor_history_recent', 'at', 'timestamp with time zone');
SELECT col_not_null('sensor_history_recent', 'at');

SELECT col_is_pk('sensor_history_recent', ARRAY['gateway_id', 'device_id', 'module_id', 'at']);

SELECT has_column('sensor_history_recent', 'value');
SELECT col_type_is('sensor_history_recent', 'value', 'real');
SELECT col_is_null('sensor_history_recent', 'value');

SELECT finish();
ROLLBACK;
