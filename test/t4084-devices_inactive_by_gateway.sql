SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/devices.fetch_inactive_by_gateway.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION devices_inactive_by_gateway(bigint)
RETURNS SETOF beeeon.device AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT lives_ok(
	$$ SELECT * FROM devices_inactive_by_gateway(1157178494608281) $$,
	'there is no reason to fail'
);

SELECT finish();
ROLLBACK;
