-- beeeon-server, pg

BEGIN;

CREATE SCHEMA beeeon;

CREATE ROLE beeeon_user WITH LOGIN;
REVOKE ALL
	ON SCHEMA beeeon
	FROM beeeon_user;
REVOKE ALL
	ON ALL TABLES IN SCHEMA beeeon
	FROM beeeon_user;
GRANT USAGE ON SCHEMA beeeon
	TO beeeon_user;

COMMIT;
