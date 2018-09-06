-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.gateways
	DROP CONSTRAINT check_name_valid;

COMMIT;
