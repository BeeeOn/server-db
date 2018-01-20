-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.devices_inactive_by_gateway(
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
			NULL::bigint
		FROM beeeon.devices
		WHERE
			active_since IS NULL
			AND
			gateway_id = _gateway_id;
END;
$$ LANGUAGE plpgsql;

COMMIT;
