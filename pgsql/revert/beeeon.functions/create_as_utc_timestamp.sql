-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.as_utc_timestamp(bigint);
DROP FUNCTION beeeon.as_utc_timestamp_us(bigint);

COMMIT;
