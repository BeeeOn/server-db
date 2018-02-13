SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/locations.fetch_by_gateway_id.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION locations_by_gateway(bigint)
RETURNS TABLE (
	id uuid,
	name varchar(250),
	gateway_id bigint
) AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM locations_by_gateway(1115569803521760) $$,
	'there is nothing yet in the locations table'
);

SELECT finish();
ROLLBACK;
