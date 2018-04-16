-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.devices
	DROP CONSTRAINT check_name_valid;

COMMIT;
