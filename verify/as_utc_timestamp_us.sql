-- beeeon-server, pg

BEGIN;

SELECT has_function_privilege(
	'beeeon.as_utc_timestamp_us(bigint)',
	'execute'
);

SELECT 1 / COUNT(*)
	FROM pg_proc
	JOIN pg_namespace ON pronamespace = pg_namespace.oid
	WHERE
		proname = 'as_utc_timestamp_us'
		AND
		nspname = 'beeeon'
		AND
		pg_get_functiondef(pg_proc.oid) NOT LIKE $$%make_interval%$$;

ROLLBACK;
