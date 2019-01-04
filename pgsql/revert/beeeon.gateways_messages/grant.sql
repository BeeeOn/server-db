-- beeeon-server, pg

BEGIN;

REVOKE SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.gateways_messages
	FROM beeeon_user;

COMMIT;
