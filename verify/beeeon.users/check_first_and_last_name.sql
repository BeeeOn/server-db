-- beeeon-server, pg

BEGIN;

SELECT 1 / COUNT(*)
	FROM pg_constraint c
	JOIN pg_namespace n ON c.connamespace = n.oid
	JOIN pg_class s ON c.conrelid = s.oid
WHERE
	n.nspname = 'beeeon'
	AND
	s.relname = 'users'
	AND
	c.conname = 'check_first_and_last_name_valid';

ROLLBACK;
