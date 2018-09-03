-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

---
-- Data in this table should live only for a limited amount of time.
-- After a while, it should be moved into some more efficient storage
-- either inside PostgreSQL or in some other external database.
---
CREATE TABLE beeeon.sensor_history_recent (
	gateway_id bigint NOT NULL,
	device_id bigint NOT NULL,
	module_id smallint NOT NULL,
	at timestamp NOT NULL,
	value real,

	CONSTRAINT sensor_history_recent_pk PRIMARY KEY (gateway_id, device_id, module_id, at),
	CONSTRAINT sensor_history_recent_gateway_fk FOREIGN KEY (gateway_id)
		REFERENCES beeeon.gateways (id),
	CONSTRAINT sensor_history_recent_device_fk FOREIGN KEY (gateway_id, device_id)
		REFERENCES beeeon.devices (gateway_id, id)
);

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.sensor_history_recent
	TO beeeon_user;


COMMIT;
