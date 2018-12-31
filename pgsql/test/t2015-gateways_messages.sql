SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(17);

SELECT has_table('gateways_messages');
SELECT has_pk('gateways_messages');

SELECT has_column('gateways_messages', 'id');
SELECT col_type_is('gateways_messages', 'id', 'uuid');
SELECT col_is_pk('gateways_messages', 'id');

SELECT has_column('gateways_messages', 'gateway_id');
SELECT col_type_is('gateways_messages', 'gateway_id', 'bigint');
SELECT col_is_fk('gateways_messages', 'gateway_id');

SELECT has_column('gateways_messages', 'at');
SELECT col_type_is('gateways_messages', 'at', 'timestamp without time zone');

SELECT has_column('gateways_messages', 'key');
SELECT col_type_is('gateways_messages', 'key', 'character varying(64)');

SELECT has_column('gateways_messages', 'severity');
SELECT col_type_is('gateways_messages', 'severity', 'smallint');

SELECT has_column('gateways_messages', 'context');
SELECT col_type_is('gateways_messages', 'context', 'jsonb');

INSERT INTO beeeon.gateways (id, name, altitude, latitude, longitude)
VALUES (
	1074353332793069,
	'testing',
	0.0,
	0.0,
	0.0
);

SELECT throws_ok($$
	INSERT INTO beeeon.gateways_messages (id, gateway_id, key, severity)
	VALUES (
		'77888199-2736-4b6a-a6c6-189232efb19f',
		1074353332793069,
		'invalid severity',
		-1
	)
	$$,
	23514,
	NULL);

SELECT finish();
ROLLBACK;
