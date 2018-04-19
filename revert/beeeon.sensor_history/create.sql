-- beeeon-server, pg

BEGIN;

DROP RULE insert_rule ON beeeon.sensor_history;
DROP FUNCTION beeeon.insert_into_sensor_history(
		beeeon.sensor_history);

---
-- Revert the sensors_init_trigger that inits the apropriate
-- sensor period and provides its refid as introduced by change
-- beeeon.sensor_history_raw/add_column_refid.
---
CREATE OR REPLACE FUNCTION beeeon.sensors_init_trigger()
RETURNS TRIGGER AS
$$
DECLARE
	_refid integer;
BEGIN
	SELECT beeeon.sensors_init(
		NEW.gateway_id,
		NEW.device_id,
		NEW.module_id
	) INTO _refid;

	NEW.refid = _refid;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sensors_init_before_insert
	BEFORE INSERT
	ON beeeon.sensor_history_raw
	FOR EACH ROW EXECUTE
		PROCEDURE beeeon.sensors_init_trigger();

DROP VIEW beeeon.sensor_history;

COMMIT;
