SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(56);

SELECT has_function('align_timestamp');

-- align to 5 seconds
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:05.0', 5), timestamp '2018-1-15 09:57:05');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:09.1', 5), timestamp '2018-1-15 09:57:05');

-- align to 10 seconds
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:00.0', 10), timestamp '2018-1-15 09:57:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:10.5', 10), timestamp '2018-1-15 09:57:10');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:19.9', 10), timestamp '2018-1-15 09:57:10');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:21.0', 10), timestamp '2018-1-15 09:57:20');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:29.9', 10), timestamp '2018-1-15 09:57:20');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:31.0', 10), timestamp '2018-1-15 09:57:30');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:41.0', 10), timestamp '2018-1-15 09:57:40');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:59.0', 10), timestamp '2018-1-15 09:57:50');

-- align to 30 seconds
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:00.0', 30), timestamp '2018-1-15 09:57:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:10.0', 30), timestamp '2018-1-15 09:57:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:39.1', 30), timestamp '2018-1-15 09:57:30');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:59.1', 30), timestamp '2018-1-15 09:57:30');

-- align to 1 minute
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:00.0', 60), timestamp '2018-1-15 09:57:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:10.9', 60), timestamp '2018-1-15 09:57:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:01.3', 60), timestamp '2018-1-15 09:57:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:59.3', 60), timestamp '2018-1-15 09:57:00');

-- align to 5 minutes
SELECT is(align_timestamp(timestamp '2018-1-15 09:00:00.0', 5 * 60), timestamp '2018-1-15 09:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:11:00.0', 5 * 60), timestamp '2018-1-15 09:10:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:11:45.1', 5 * 60), timestamp '2018-1-15 09:10:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:16:00.0', 5 * 60), timestamp '2018-1-15 09:15:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:16:32.9', 5 * 60), timestamp '2018-1-15 09:15:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:50:00.0', 5 * 60), timestamp '2018-1-15 09:50:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:55:00.0', 5 * 60), timestamp '2018-1-15 09:55:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:10.0', 5 * 60), timestamp '2018-1-15 09:55:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:59:59.9', 5 * 60), timestamp '2018-1-15 09:55:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:54:58.2', 5 * 60), timestamp '2018-1-15 09:50:00');

-- align to 10 minutes
SELECT is(align_timestamp(timestamp '2018-1-15 09:40:00.0', 10 * 60), timestamp '2018-1-15 09:40:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:49:59.9', 10 * 60), timestamp '2018-1-15 09:40:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:50:00.0', 10 * 60), timestamp '2018-1-15 09:50:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:59:59.9', 10 * 60), timestamp '2018-1-15 09:50:00');

-- align to 30 minutes
SELECT is(align_timestamp(timestamp '2018-1-15 09:00:00.0', 30 * 60), timestamp '2018-1-15 09:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:29:59.9', 30 * 60), timestamp '2018-1-15 09:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:59:59.9', 30 * 60), timestamp '2018-1-15 09:30:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:57:10.6', 30 * 60), timestamp '2018-1-15 09:30:00');
SELECT is(align_timestamp(timestamp '2018-1-15 10:57:10.6', 30 * 60), timestamp '2018-1-15 10:30:00');

-- align to 1 hour
SELECT is(align_timestamp(timestamp '2018-1-15 09:00:00.0', 60 * 60), timestamp '2018-1-15 09:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:59:59.9', 60 * 60), timestamp '2018-1-15 09:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 10:00:00.0', 60 * 60), timestamp '2018-1-15 10:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 10:57:10.6', 60 * 60), timestamp '2018-1-15 10:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 11:01:00.1', 60 * 60), timestamp '2018-1-15 11:00:00');

-- align to 5 hours
SELECT is(align_timestamp(timestamp '2018-1-15 00:00:00.0', 5 * 60 * 60), timestamp '2018-1-15 00:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 04:59:59.9', 5 * 60 * 60), timestamp '2018-1-15 00:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 05:00:00.0', 5 * 60 * 60), timestamp '2018-1-15 05:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 09:59:59.9', 5 * 60 * 60), timestamp '2018-1-15 05:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 10:00:00.0', 5 * 60 * 60), timestamp '2018-1-15 10:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 10:59:59.9', 5 * 60 * 60), timestamp '2018-1-15 10:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 11:01:00.1', 5 * 60 * 60), timestamp '2018-1-15 10:00:00');

-- align to 24 hours
SELECT is(align_timestamp(timestamp '2018-1-15 00:00:00.0', 24 * 60 * 60), timestamp '2018-1-15 00:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 12:00:00.0', 24 * 60 * 60), timestamp '2018-1-15 00:00:00');
SELECT is(align_timestamp(timestamp '2018-1-15 23:59:59.9', 24 * 60 * 60), timestamp '2018-1-15 00:00:00');
SELECT is(align_timestamp(timestamp '2018-1-16 00:00:00.0', 24 * 60 * 60), timestamp '2018-1-16 00:00:00');
SELECT is(align_timestamp(timestamp '2018-1-16 12:00:00.0', 24 * 60 * 60), timestamp '2018-1-16 00:00:00');
SELECT is(align_timestamp(timestamp '2018-1-16 23:59:59.9', 24 * 60 * 60), timestamp '2018-1-16 00:00:00');

SELECT finish();
ROLLBACK;
