SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/locations.fetch_by_id_and_gateway_id.sql`; $$

BEGIN;

SELECT plan(1);

CREATE OR REPLACE FUNCTION locations_by_id_and_gateway(uuid, bigint)
RETURNS SETOF beeeon.location AS :query LANGUAGE SQL;

SELECT is_empty(
	$$ SELECT * FROM locations_by_id_and_gateway('cc72f7ea-e8be-4379-8bf5-4cf26749b049', 1240795450208837) $$,
	'there is nothing yet in the locations table'
);

SELECT finish();
ROLLBACK;
