SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(13);

SELECT has_table('gateways_status');
SELECT has_pk('gateways_status');
SELECT has_fk('gateways_status');

SELECT col_is_pk('gateways_status', ARRAY['gateway_id', 'at']);

SELECT has_column('gateways_status', 'gateway_id');
SELECT col_type_is('gateways_status', 'gateway_id', 'bigint');
SELECT col_is_fk('gateways_status', 'gateway_id');

SELECT has_column('gateways_status', 'at');
SELECT col_type_is('gateways_status', 'at', 'timestamp with time zone');

SELECT has_column('gateways_status', 'version');
SELECT col_type_is('gateways_status', 'version', 'character varying(40)');

SELECT has_column('gateways_status', 'ip');
SELECT col_type_is('gateways_status', 'ip', 'inet');

SELECT finish();
ROLLBACK;
