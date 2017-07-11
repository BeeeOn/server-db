-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_type('beeeon', 'device');
SELECT beeeon.assure_function('beeeon', 'to_device_id(numeric)');
SELECT beeeon.assure_function('beeeon', 'to_device_id(varchar)');
SELECT beeeon.assure_function('beeeon', 'to_device_id(bigint)');
SELECT beeeon.assure_function('beeeon', 'from_device_id(bigint)');

ROLLBACK;
