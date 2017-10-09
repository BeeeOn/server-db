-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.assure_type(text, text);
DROP FUNCTION beeeon.assure_function(text, text);
DROP FUNCTION beeeon.assure_table_priviledges(text, text, text[]);
DROP FUNCTION beeeon.assure_true(bool, text);
DROP FUNCTION beeeon.always_fail(text);

REVOKE ALL
	ON ALL TABLES IN SCHEMA beeeon
	FROM beeeon_user;
REVOKE ALL
	ON SCHEMA beeeon
	FROM beeeon_user;
DROP ROLE beeeon_user;

DROP SCHEMA beeeon;

COMMIT;
