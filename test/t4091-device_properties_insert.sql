SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat _api/devices_properties.insert.sql`

BEGIN;

PREPARE device_properties_insert(numeric, bigint, smallint, text, text)
AS :query;

SELECT plan(1);

SELECT throws_ok(
	$$ EXECUTE device_properties_insert(
		11678152912333531136,
		1240795450208837,
		0::smallint,
		'any arbitrary data'::text,
		NULL::text
	) $$,
	23503,
	NULL,
	'no such device and gateway exist'
);

SELECT finish();
ROLLBACK;
