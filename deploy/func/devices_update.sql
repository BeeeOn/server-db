-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.devices_update(
	_id numeric(20, 0),
	_gateway_id bigint,
	_location_id uuid,
	_name varchar(250),
	_type smallint,
	_refresh integer,
	_battery smallint,
	_signal smallint,
	_active_since bigint

)
RETURNS boolean AS
$$
BEGIN
	UPDATE beeeon.devices
	SET
		location_id = _location_id,
		name = _name,
		type = _type,
		refresh = _refresh,
		battery = _battery,
		signal = _signal,
		last_seen = NOW(),
		active_since = to_timestamp(_active_since)
	WHERE
		id = beeeon.to_device_id(_id)
		AND
		gateway_id = _gateway_id;

	RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

COMMIT;
