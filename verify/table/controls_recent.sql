-- beeeon-server, pg

BEGIN;

SELECT 0 / CASE WHEN COUNT(*) > 0 THEN 0 ELSE 1 END
	FROM pg_tables
	WHERE schemaname = 'beeeon' AND tablename = 'controls_recent';

ROLLBACK;
