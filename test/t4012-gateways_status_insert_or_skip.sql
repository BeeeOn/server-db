SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat pgsql/gateways_status/insert.sql`

BEGIN;

PREPARE gateways_status_insert_or_skip(
	bigint, bigint, varchar, varchar)
AS :query;

SELECT plan(13);

SELECT is(COUNT(*)::integer, 0, 'there should be no status of 1151460236578635 yet')
	FROM gateways_status
	WHERE gateway_id = 1151460236578635;

SELECT throws_ok(
	$$ EXECUTE gateways_status_insert_or_skip(
		1151460236578635,
		extract(epoch FROM timestamp '2017-7-7 22:29:51')::bigint,
		'master',
		'192.168.0.3'
	) $$,
	23503,
	NULL,
	'attempt to insert status for non-existing gateway 1151460236578635'
);

-- provide a gateway to allow successful inserts
INSERT INTO gateways (id, name, altitude, latitude, longitude)
	VALUES (1151460236578635, 'testing', 1, 2, 3);

SELECT lives_ok(
	$$ EXECUTE gateways_status_insert_or_skip(
		1151460236578635,
		extract(epoch FROM timestamp '2017-7-7 22:29:51')::bigint,
		'master',
		'192.168.0.3'
	) $$,
	'gateway 1151460236578635 is present, insert should work'
);

SELECT ok(EXISTS(
	SELECT 1 FROM gateways_status
		WHERE
			gateway_id = 1151460236578635
			AND
			at = timestamp '2017-7-7 22:29:51'
			AND
			version = 'master'
			AND
			ip = '192.168.0.3'
	),
	'there should be exactly one status for gateway 1151460236578635'
);

SELECT lives_ok(
	$$ EXECUTE gateways_status_insert_or_skip(
		1151460236578635,
		extract(epoch FROM timestamp '2017-7-8 01:16:31')::bigint,
		'master',
		'192.168.0.3'
	) $$,
	'updating an existing status should not fail'
);

-- TODO: improve to save the last two equivalent states.
--
-- Example:
--
--  1151460236578635, '2017-7-7 22:29:51', master, 192.168.0.3
--  1151460236578635, '2017-7-8 01:16:31', master, 192.168.0.3
--
-- ...now, all other inserts would update the last record
-- and thus we know that the gateway is alive. When the status
-- is to be updated again with the same data, we would just
-- update the last timestamp:
--
--  1151460236578635, '2017-7-7 22:29:51', master, 192.168.0.3
--  1151460236578635, '2017-7-8 14:03:11', master, 192.168.0.3

SELECT results_eq(
	$$ SELECT MAX(at) FROM gateways_status $$,
	ARRAY [timestamp '2017-7-7 22:29:51'],
	'the last insert should have been skipped (no real change)'
);

SELECT lives_ok(
	$$ EXECUTE gateways_status_insert_or_skip(
		1151460236578635,
		extract(epoch FROM timestamp '2017-7-8 06:49:51')::bigint,
		'testing',
		'192.168.0.3'
	) $$,
	'updating an existing status should not fail'
);

SELECT ok(EXISTS(
	SELECT 1 FROM gateways_status
		WHERE
			gateway_id = 1151460236578635
			AND
			at = timestamp '2017-7-8 06:49:51'
			AND
			version = 'testing'
			AND
			ip = '192.168.0.3'
	),
	'version must have been updated'
);

SELECT lives_ok(
	$$ EXECUTE gateways_status_insert_or_skip(
		1151460236578635,
		extract(epoch FROM timestamp '2017-7-8 07:23:11')::bigint,
		'testing',
		'192.168.0.4'
	) $$,
	'updating an existing status should not fail'
);

SELECT ok(EXISTS(
	SELECT 1 FROM gateways_status
		WHERE
			gateway_id = 1151460236578635
			AND
			at = timestamp '2017-7-8 07:23:11'
			AND
			version = 'testing'
			AND
			ip = '192.168.0.4'
	),
	'ip must have been updated'
);

SELECT lives_ok(
	$$ EXECUTE gateways_status_insert_or_skip(
		1151460236578635,
		extract(epoch from timestamp '2017-10-30 05:53:11')::bigint,
		'master',
		'192.168.1.4'
	) $$,
	'updating an existing status should not fail'
);

SELECT ok(EXISTS(
	SELECT 1 FROM gateways_status
		WHERE
			gateway_id = 1151460236578635
			AND
			at = timestamp '2017-10-30 05:53:11'
			AND
			version = 'master'
			AND
			ip = '192.168.1.4'
	),
	'both version and ip must have been updated'
);

SELECT is(COUNT(*)::integer, 4, 'exactly 4 updates has succeeded') FROM gateways_status;

SELECT finish();
ROLLBACK;
