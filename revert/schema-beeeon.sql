-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.assure_type(text, text);
DROP FUNCTION beeeon.assure_function(text, text);
DROP FUNCTION beeeon.always_fail(text);

DROP SCHEMA beeeon;

COMMIT;
