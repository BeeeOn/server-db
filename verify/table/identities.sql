-- beeeon-server, pg

BEGIN;

SELECT id, email FROM beeeon.identities WHERE FALSE;

ROLLBACK;
