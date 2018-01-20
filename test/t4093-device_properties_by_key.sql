SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/devices_properties.fetch.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION device_properties_by_key(numeric, bigint, smallint)
RETURNS SETOF beeeon.device_property AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM device_properties_by_key(11678152912333531136, 1240795450208837, 0::smallint) $$,
	'there is nothing yet in the device_properties table'
);

SELECT finish();
ROLLBACK;
