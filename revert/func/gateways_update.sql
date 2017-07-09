-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.gateways_update(bigint, varchar(250), integer, double precision, double precision);

COMMIT;
