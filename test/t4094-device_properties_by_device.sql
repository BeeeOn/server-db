SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/devices_properties.fetch_by_device.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION device_properties_by_device(numeric, bigint)
RETURNS TABLE (
	device_id varchar,
	gateway_id bigint,
	key smallint,
	value text,
	params text
) AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM device_properties_by_device(11678152912333531136, 1240795450208837) $$,
	'there is nothing yet in the device_properties table'
);

SELECT finish();
ROLLBACK;
