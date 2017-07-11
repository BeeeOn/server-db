-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_type('beeeon', 'role_in_gateway');

ROLLBACK;
