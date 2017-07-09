-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.device_properties (
	device_id bigint NOT NULL,
	gateway_id bigint NOT NULL,
	key smallint NOT NULL,
	value text,
	params text,
	CONSTRAINT device_properties_pk PRIMARY KEY (gateway_id, device_id, key),
	CONSTRAINT device_properties_devices_fk FOREIGN KEY (gateway_id, device_id) REFERENCES beeeon.devices (gateway_id, id),
	CONSTRAINT device_properties_gateways_fk FOREIGN KEY (gateway_id) REFERENCES beeeon.gateways (id)
);

COMMIT;
