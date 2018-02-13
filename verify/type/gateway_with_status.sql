-- beeeon-server, pg

BEGIN;

SELECT 1 / CASE WHEN COUNT(*) > 0 THEN 0 ELSE 1 END
	FROM pg_catalog.pg_type t
	JOIN pg_catalog.pg_namespace n ON t.typnamespace = n.oid
	WHERE t.typisdefined
		AND n.nspname = 'beeeon'
		AND t.typname = 'gateway_with_status';

ROLLBACK;
