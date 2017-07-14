-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.device_properties_update(
	_device_id numeric,
	_gateway_id bigint,
	_key smallint,
	_value text,
	_params text
)
RETURNS boolean AS
$$
BEGIN
	UPDATE beeeon.device_properties
	SET
		value = _value,
		params = _params
	WHERE
		device_id = beeeon.to_device_id(_device_id)
		AND
		gateway_id = _gateway_id
		AND
		key = _key;

	RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

COMMIT;
