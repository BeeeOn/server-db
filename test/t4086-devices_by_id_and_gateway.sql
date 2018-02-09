SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/devices.fetch_from_gateway.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION devices_by_id_and_gateway(numeric(20, 0), bigint)
RETURNS SETOF beeeon.device AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT lives_ok(
	$$ SELECT * FROM devices_by_id_and_gateway(11678152912333531136::numeric(20, 0), 1157178494608281) $$,
	'there is no reason to fail'
);

SELECT finish();
ROLLBACK;
