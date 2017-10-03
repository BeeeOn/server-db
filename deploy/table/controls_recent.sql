-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.controls_recent (
	gateway_id bigint NOT NULL,
	device_id  bigint NOT NULL,
	module_id  smallint NOT NULL,
	value real,
	at timestamp with time zone NOT NULL,
	stability beeeon.control_stability NOT NULL,
	originator_user_id uuid,

	CONSTRAINT controls_recent_pk PRIMARY KEY (gateway_id, device_id, module_id, at, stability),
	CONSTRAINT controls_recent_users_fk FOREIGN KEY (originator_user_id)
		REFERENCES beeeon.users (id),
	CONSTRAINT controls_recent_gateways_fk FOREIGN KEY (gateway_id)
		REFERENCES beeeon.gateways (id),
	CONSTRAINT controls_recent_devices_fk FOREIGN KEY (gateway_id, device_id)
		REFERENCES beeeon.devices (gateway_id, id)
);

COMMIT;
