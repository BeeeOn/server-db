-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.device_properties_by_key(
	_device_id numeric,
	_gateway_id bigint,
	_key smallint
)
RETURNS SETOF beeeon.device_property AS
$$
BEGIN
	RETURN QUERY
		SELECT
			beeeon.from_device_id(device_id),
			gateway_id,
			key,
			value,
			params
		FROM beeeon.device_properties
		WHERE
			device_id = beeeon.to_device_id(_device_id)
			AND
			gateway_id = _gateway_id
			AND
			key = _key;
END;
$$ LANGUAGE plpgsql;

COMMIT;
