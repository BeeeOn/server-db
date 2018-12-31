-- beeeon-server, pg

BEGIN;

SELECT
	id,
	gateway_id,
	at,
	severity,
	key,
	context
FROM
	beeeon.gateways_messages
WHERE
	FALSE;

ROLLBACK;
