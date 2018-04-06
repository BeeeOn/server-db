SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat pgsql/devices_properties/remove.sql`

BEGIN;

PREPARE device_properties_remove(numeric, bigint, smallint)
AS :query;

SELECT plan(1);

SELECT lives_ok(
	$$ EXECUTE device_properties_remove(11678152912333531136, 1240795450208837, 0::smallint) $$,
	'removing of non-existing device property should not fail'
);

SELECT finish();
ROLLBACK;
