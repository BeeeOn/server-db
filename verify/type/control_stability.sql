-- beeeon-server, pg

BEGIN;

SELECT 1 / CASE WHEN COUNT(*) > 0 THEN 0 ELSE 1 END
	FROM pg_catalog.pg_type t
	JOIN pg_catalog.pg_namespace n ON t.typnamespace = n.oid
	WHERE t.typisdefined
		AND n.nspname = 'beeeon'
		AND t.typname = 'control_stability';

SELECT 0 / CASE WHEN COUNT(*) > 0 THEN 0 ELSE 1 END
	FROM pg_proc JOIN pg_namespace ON pronamespace = pg_namespace.oid
	WHERE proname = 'to_control_stability' AND nspname = 'beeeon';

SELECT 0 / CASE WHEN COUNT(*) > 0 THEN 0 ELSE 1 END
	FROM pg_proc JOIN pg_namespace ON pronamespace = pg_namespace.oid
	WHERE proname = 'from_control_stability' AND nspname = 'beeeon';

SELECT 0 / CASE WHEN COUNT(*) > 0 THEN 0 ELSE 1 END
	FROM pg_proc JOIN pg_namespace ON pronamespace = pg_namespace.oid
	WHERE proname = 'control_stability_is_confirmed' AND nspname = 'beeeon';

ROLLBACK;
