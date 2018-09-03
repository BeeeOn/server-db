-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.devices (
	id bigint NOT NULL,
	gateway_id bigint NOT NULL,
	location_id uuid DEFAULT NULL,
	name varchar(250) NOT NULL,
	type smallint NOT NULL,
	refresh integer NOT NULL DEFAULT 10,
	battery smallint DEFAULT NULL,
	signal smallint DEFAULT NULL,
	first_seen timestamp NOT NULL,
	last_seen timestamp NOT NULL,
	active_since timestamp DEFAULT NULL,
	CONSTRAINT devices_pk PRIMARY KEY (gateway_id, id),
	CONSTRAINT devices_gateways_fk FOREIGN KEY (gateway_id) REFERENCES beeeon.gateways (id),
	CONSTRAINT devices_locations_fk FOREIGN KEY (location_id) REFERENCES beeeon.locations (id),
	CONSTRAINT check_seen_valid CHECK (first_seen <= last_seen),
	CONSTRAINT check_active_valid CHECK (active_since IS NULL OR first_seen <= active_since),
	CONSTRAINT check_battery_valid CHECK (battery IS NULL OR (battery >= 0 AND battery <= 100)),
	CONSTRAINT check_signal_valid CHECK (signal IS NULL OR (signal >= 0 AND signal <= 100))
);

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.devices
	TO beeeon_user;

COMMIT;
