---
-- Delete all devices with no sensor data history.
-- This query should effectively delete devices that
-- have never been paired or unpaired devices with
-- no history data at all.
---
DELETE
FROM
	beeeon.devices AS d
WHERE
	d.active_since IS NULL
	AND NOT EXISTS (
		SELECT 1
		FROM
			beeeon.sensor_history_recent AS s
		WHERE
			s.gateway_id = d.gateway_id
			AND
			s.device_id = d.id
	)
