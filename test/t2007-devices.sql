SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(41);

SELECT has_table('devices');
SELECT has_pk('devices');

SELECT has_column('devices', 'id');
SELECT col_type_is('devices', 'id', 'bigint');
SELECT col_is_pk('devices', ARRAY['gateway_id', 'id']);
SELECT col_not_null('devices', 'id');

SELECT has_column('devices', 'gateway_id');
SELECT col_type_is('devices', 'gateway_id', 'bigint');
SELECT col_is_fk('devices', 'gateway_id');
SELECT col_not_null('devices', 'gateway_id');

SELECT has_column('devices', 'location_id');
SELECT col_type_is('devices', 'location_id', 'uuid');
SELECT col_is_fk('devices', 'location_id');
SELECT col_is_null('devices', 'location_id');

SELECT has_column('devices', 'name');
SELECT col_type_is('devices', 'name', 'character varying(250)');
SELECT col_not_null('devices', 'name');

SELECT has_column('devices', 'type');
SELECT col_type_is('devices', 'type', 'smallint');
SELECT col_not_null('devices', 'type');

SELECT has_column('devices', 'refresh');
SELECT col_type_is('devices', 'refresh', 'integer');
SELECT col_not_null('devices', 'refresh');

SELECT has_column('devices', 'battery');
SELECT col_type_is('devices', 'battery', 'smallint');
SELECT col_has_check('devices', 'battery');
SELECT col_is_null('devices', 'battery');

SELECT has_column('devices', 'signal');
SELECT col_type_is('devices', 'signal', 'smallint');
SELECT col_has_check('devices', 'signal');
SELECT col_is_null('devices', 'signal');

SELECT has_column('devices', 'first_seen');
SELECT col_type_is('devices', 'first_seen', 'timestamp with time zone');
SELECT col_not_null('devices', 'first_seen');

SELECT has_column('devices', 'last_seen');
SELECT col_type_is('devices', 'last_seen', 'timestamp with time zone');
SELECT col_not_null('devices', 'last_seen');

SELECT col_has_check('devices', ARRAY['first_seen', 'last_seen']);

SELECT has_column('devices', 'active_since');
SELECT col_type_is('devices', 'active_since', 'timestamp with time zone');
SELECT col_is_null('devices', 'active_since');

SELECT finish();
ROLLBACK;
