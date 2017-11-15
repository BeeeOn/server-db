-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.sensor_history_recent_insert(
	_gateway_id bigint,
	_device_id bigint,
	_module_id smallint,
	_at timestamp,
	_value real
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.sensor_history_recent (
		gateway_id, device_id, module_id, at, value
	)
	VALUES (
		_gateway_id, _device_id, _module_id, _at, _value
	);
$$ LANGUAGE SQL;

COMMIT;
