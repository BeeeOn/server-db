-- beeeon-server, pg

BEGIN;

SELECT has_function_privilege(
	'beeeon.as_utc_timestamp(bigint)',
	'execute'
);

SELECT has_function_privilege(
	'beeeon.as_utc_timestamp_us(bigint)',
	'execute'
);

ROLLBACK;
