-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.locations
	DROP CONSTRAINT check_name_valid;

COMMIT;
