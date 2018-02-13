-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_type('beeeon', 'gateway_with_status');

ROLLBACK;
