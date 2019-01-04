-- beeeon-server, pg

BEGIN;

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.gateways_messages
	TO beeeon_user;

COMMIT;
