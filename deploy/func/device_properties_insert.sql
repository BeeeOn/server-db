-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.device_properties_insert(
	_device_id numeric,
	_gateway_id bigint,
	_key smallint,
	_value text,
	_params text
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.device_properties(
		device_id,
		gateway_id,
		key,
		value,
		params
	)
	VALUES (
		beeeon.to_device_id(_device_id),
		_gateway_id,
		_key,
		_value,
		_params
	);
$$ LANGUAGE SQL;

COMMIT;
