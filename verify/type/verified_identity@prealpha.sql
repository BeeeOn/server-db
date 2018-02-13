-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_type('beeeon', 'verified_identity');

ROLLBACK;
