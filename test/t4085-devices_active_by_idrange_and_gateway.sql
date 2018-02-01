SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/devices.fetch_active_by_gateway_with_prefix.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION devices_active_by_idrange_and_gateway(bigint, numeric(20, 0), numeric(20, 0))
RETURNS SETOF beeeon.device AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM devices_active_by_idrange_and_gateway(1157178494608281, 11673330234144325632, 11745387828182253567) $$,
	'there is nothing yet in the devices table'
);

SELECT finish();
ROLLBACK;
