SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(20);

SELECT has_type('device');
SELECT has_function('to_device_id');
SELECT has_function('from_device_id');

SELECT is(to_device_id('0'), 0::bigint);
SELECT is(to_device_id('4294967295'), 4294967295::bigint);
SELECT is(to_device_id('4294967296'), 4294967296::bigint);
SELECT is(to_device_id('11678152912333531136'), -6768591161376020480::bigint);
SELECT is(to_device_id('18446744073709551615'), -1::bigint);

SELECT is(to_device_id(0::numeric), 0::bigint);
SELECT is(to_device_id(4294967295::numeric), 4294967295::bigint);
SELECT is(to_device_id(4294967296::numeric), 4294967296::bigint);
SELECT is(to_device_id(11678152912333531136::numeric), -6768591161376020480::bigint);
SELECT is(to_device_id(18446744073709551615::numeric), -1::bigint);

SELECT throws_ok(
	$$ SELECT to_device_id('18446744073709551616') $$,
	'P0001',
	NULL,
	'too big device ID should throw an exception'
);

SELECT throws_ok(
	$$ SELECT to_device_id('-1') $$,
	'P0001',
	NULL,
	'negative device ID should throw an exception'
);


SELECT is(from_device_id(0::bigint), '0');
SELECT is(from_device_id(4294967295::bigint), '4294967295');
SELECT is(from_device_id(4294967296::bigint), '4294967296');
SELECT is(from_device_id(-6768591161376020480::bigint), '11678152912333531136');
SELECT is(from_device_id(-1::bigint), '18446744073709551615');

SELECT finish();
ROLLBACK;
