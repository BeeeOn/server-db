-- beeeon-server, pg

BEGIN;

SELECT 0 / CASE WHEN COUNT(*) > 0 THEN 0 ELSE 1 END
	FROM pg_proc JOIN pg_namespace ON pronamespace = pg_namespace.oid
	WHERE proname = 'fcm_recipients_by_gateway' AND nspname = 'beeeon';

ROLLBACK;