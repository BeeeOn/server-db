-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.device_properties_remove(
	_device_id numeric,
	_gateway_id bigint,
	_key smallint
)
RETURNS VOID AS
$$
	DELETE FROM beeeon.device_properties
	WHERE
		device_id = beeeon.to_device_id(_device_id)
		AND
		gateway_id = _gateway_id
		AND
		key = _key;
$$ LANGUAGE SQL;

COMMIT;
