SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ BEGIN '`cat queries/devices_properties/update.sql`; 'RETURN FOUND; END;' $$

BEGIN;

CREATE OR REPLACE FUNCTION device_properties_update(
	text, text, numeric, bigint, smallint)
RETURNS boolean AS :query LANGUAGE plpgsql;

SELECT plan(1);

SELECT ok(
	NOT device_properties_update(
		'anything'::text,
		NULL::text,
		11678152912333531136,
		1240795450208837::bigint,
		0::smallint
	),
	'there is nothing to update'
);

SELECT finish();
ROLLBACK;
