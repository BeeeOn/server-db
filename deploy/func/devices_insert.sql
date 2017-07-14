-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.devices_insert(
	_id numeric(20, 0),
	_gateway_id bigint,
	_location_id uuid,
	_name varchar(250),
	_type smallint,
	_refresh integer,
	_battery smallint,
	_signal smallint,
	_first_seen bigint,
	_last_seen bigint,
	_active_since bigint
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.devices (
		id,
		gateway_id,
		location_id,
		name,
		type,
		refresh,
		battery,
		signal,
		first_seen,
		last_seen,
		active_since
	)
	VALUES (
		beeeon.to_device_id(_id),
		_gateway_id,
		_location_id,
		_name,
		_type,
		_refresh,
		_battery,
		_signal,
		to_timestamp(_first_seen),
		to_timestamp(_last_seen),
		to_timestamp(_active_since)
	);
$$ LANGUAGE SQL;

COMMIT;
