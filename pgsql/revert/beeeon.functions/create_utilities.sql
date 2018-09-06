-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.assure_type(text, text);
DROP FUNCTION beeeon.assure_function(text, text);
DROP FUNCTION beeeon.assure_table_priviledges(text, text, text[]);
DROP FUNCTION beeeon.assure_true(bool, text);
DROP FUNCTION beeeon.always_fail(text);

COMMIT;
