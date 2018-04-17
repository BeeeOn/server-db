-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.users
	DROP CONSTRAINT check_first_and_last_name_valid;

COMMIT;
