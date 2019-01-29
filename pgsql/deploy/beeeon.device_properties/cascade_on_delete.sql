-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.device_properties
	DROP CONSTRAINT device_properties_devices_fk,
	ADD CONSTRAINT device_properties_devices_fk
		FOREIGN KEY (gateway_id, device_id)
		REFERENCES beeeon.devices (gateway_id, id)
		ON DELETE CASCADE;

COMMIT;
