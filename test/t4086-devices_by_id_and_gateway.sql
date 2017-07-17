SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('devices_by_id_and_gateway');

SELECT lives_ok(
	$$ SELECT * FROM devices_by_id_and_gateway(11678152912333531136::numeric(20, 0), 1157178494608281) $$,
	'there is no reason to fail'
);

SELECT finish();
ROLLBACK;
