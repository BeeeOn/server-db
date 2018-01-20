-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.gateways_insert(bigint, varchar(250), integer, double precision, double precision, varchar(64));

COMMIT;
