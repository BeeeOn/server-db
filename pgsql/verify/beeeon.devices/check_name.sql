-- beeeon-server, pg

BEGIN;

SELECT 1 / COUNT(*)
	FROM pg_constraint c
	JOIN pg_namespace n ON c.connamespace = n.oid
	JOIN pg_class s ON c.conrelid = s.oid
WHERE
	n.nspname = 'beeeon'
	AND
	s.relname = 'devices'
	AND
	c.conname = 'check_name_valid';

ROLLBACK;
