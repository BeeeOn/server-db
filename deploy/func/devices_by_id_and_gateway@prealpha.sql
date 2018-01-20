-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.devices_by_id_and_gateway(
	_id numeric(20, 0),
	_gateway_id bigint
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
			id = beeeon.to_device_id(_id)
			AND
			gateway_id = _gateway_id
		LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMIT;
