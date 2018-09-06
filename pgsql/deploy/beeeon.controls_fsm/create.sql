-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

---
-- Store history of controls manipulation. Each control module can be
-- set to a different value. The transition to the new value is represented
-- as a FSM:
-- <pre>
-- *finished -+
--            |
-- *failed +  | user
--          \ |
--      user \|
--            V              gateway
--       *requested +--------------
--                  |\__           \
--                  |   | gateway   \_
--                 /    |             |
--                /     V             V
--               |   *accepted ---> *finished
--    gateway/   |        /
--       timeout |  _____/
--               | / gateway/timeout
--               |/
--               V
--           *failed
-- </pre>
---
CREATE TABLE beeeon.controls_fsm (
	gateway_id bigint NOT NULL,
	device_id  bigint NOT NULL,
	module_id  smallint NOT NULL,
	value real NOT NULL,
	requested_at timestamp NOT NULL,
	accepted_at timestamp,
	finished_at timestamp,
	failed boolean NOT NULL DEFAULT false,
	originator_user_id uuid NOT NULL,

	CONSTRAINT controls_fsm_pk PRIMARY KEY (gateway_id, device_id, module_id, requested_at),
	CONSTRAINT controls_fsm_users_fk FOREIGN KEY (originator_user_id)
		REFERENCES beeeon.users (id),
	CONSTRAINT controls_fsm_gateways_fk FOREIGN KEY (gateway_id)
		REFERENCES beeeon.gateways (id),
	CONSTRAINT controls_fsm_devices_fk FOREIGN KEY (gateway_id, device_id)
		REFERENCES beeeon.devices (gateway_id, id),
	CONSTRAINT controls_fsm_at_monotonic_check CHECK (
		(accepted_at IS NULL OR requested_at <= accepted_at)
		AND
		(finished_at IS NULL OR requested_at <= finished_at)
		AND
		((finished_at IS NULL OR accepted_at IS NULL) OR accepted_at <= finished_at)
	)
);

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.controls_fsm
	TO beeeon_user;

COMMIT;
