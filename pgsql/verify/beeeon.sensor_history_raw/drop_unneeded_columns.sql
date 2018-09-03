-- beeeon-server, pg

BEGIN;

SELECT
	refid,
	at,
	value
FROM
	beeeon.sensor_history_raw
WHERE
	FALSE;

DO
LANGUAGE plpgsql
$$
BEGIN
	IF EXISTS (
		SELECT 1 FROM information_schema.columns
		WHERE
			table_schema = 'beeeon'
			AND
			table_name = 'sensor_history_raw'
			AND
			column_name = 'gateway_id') THEN
		RAISE EXCEPTION 'gateway_id still present';
	END IF;

	IF EXISTS (
		SELECT 1 FROM information_schema.columns
		WHERE
			table_schema = 'beeeon'
			AND
			table_name = 'sensor_history_raw'
			AND
			column_name = 'device_id') THEN
		RAISE EXCEPTION 'device_id still present';
	END IF;

	IF EXISTS (
		SELECT 1 FROM information_schema.columns
		WHERE
			table_schema = 'beeeon'
			AND
			table_name = 'sensor_history_raw'
			AND
			column_name = 'module_id') THEN
		RAISE EXCEPTION 'module_id still present';
	END IF;
END;
$$;

ROLLBACK;
