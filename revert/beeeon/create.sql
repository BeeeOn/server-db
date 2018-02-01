-- beeeon-server, pg

BEGIN;

REVOKE ALL
	ON ALL TABLES IN SCHEMA beeeon
	FROM beeeon_user;
REVOKE ALL
	ON SCHEMA beeeon
	FROM beeeon_user;
DROP ROLE beeeon_user;

DROP SCHEMA beeeon;

COMMIT;
