-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.devices_active_by_idrange_and_gateway(
	_gateway_id bigint,
	_min_id numeric(20, 0),
	_max_id numeric(20, 0)
)
RETURNS SETOF beeeon.device AS
$$
BEGIN
	RETURN QUERY
		SELECT
			beeeon.from_device_id(id),
			gateway_id,
			location_id,
			name,
			type,
			refresh,
			battery,
			signal,
			extract(epoch FROM first_seen)::bigint,
			extract(epoch FROM last_seen)::bigint,
			extract(epoch FROM active_since)::bigint
		FROM beeeon.devices
		WHERE
			id >= beeeon.to_device_id(_min_id)
			AND
			id <= beeeon.to_device_id(_max_id)
			AND
			active_since IS NOT NULL
			AND
			gateway_id = _gateway_id;
END;
$$ LANGUAGE plpgsql;

COMMIT;
