-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'gateways_status_insert_or_skip(bigint, bigint, varchar(40), varchar(45))'
);

ROLLBACK;
