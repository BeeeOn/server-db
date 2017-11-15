SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(27);

SELECT has_table('controls_recent');
SELECT has_pk('controls_recent');

SELECT has_column('controls_recent', 'gateway_id');
SELECT col_type_is('controls_recent', 'gateway_id', 'bigint');
SELECT col_not_null('controls_recent', 'gateway_id');
SELECT col_is_fk('controls_recent', 'gateway_id');

SELECT has_column('controls_recent', 'device_id');
SELECT col_type_is('controls_recent', 'device_id', 'bigint');
SELECT col_not_null('controls_recent', 'device_id');
SELECT col_is_fk('controls_recent', ARRAY['gateway_id', 'device_id']);

SELECT has_column('controls_recent', 'module_id');
SELECT col_type_is('controls_recent', 'module_id', 'smallint');
SELECT col_not_null('controls_recent', 'module_id');

SELECT has_column('controls_recent', 'at');
SELECT col_type_is('controls_recent', 'at', 'timestamp without time zone');
SELECT col_not_null('controls_recent', 'at');

SELECT has_column('controls_recent', 'stability');
SELECT col_type_is('controls_recent', 'stability', 'control_stability');
SELECT col_not_null('controls_recent', 'stability');

SELECT col_is_pk('controls_recent', ARRAY['gateway_id', 'device_id', 'module_id', 'at', 'stability']);

SELECT has_column('controls_recent', 'value');
SELECT col_type_is('controls_recent', 'value', 'real');
SELECT col_is_null('controls_recent', 'value');

SELECT has_column('controls_recent', 'originator_user_id');
SELECT col_type_is('controls_recent', 'originator_user_id', 'uuid');
SELECT col_is_null('controls_recent', 'originator_user_id');
SELECT col_is_fk('controls_recent', 'originator_user_id');

SELECT finish();
ROLLBACK;
