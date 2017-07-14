SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('devices_active_by_idrange_and_gateway');

SELECT is_empty(
	$$ SELECT * FROM devices_active_by_idrange_and_gateway(1157178494608281, 11673330234144325632, 11745387828182253567) $$,
	'there is nothing yet in the devices table'
);

SELECT finish();
ROLLBACK;
