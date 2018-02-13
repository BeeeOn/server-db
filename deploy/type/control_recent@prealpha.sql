-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.control_recent AS (
	gateway_id bigint,
	device_id numeric(20, 0),
	module_id smallint,
	confirmed_state_at bigint,
	confirmed_state_value real,
	confirmed_state_stability smallint,
	confirmed_state_originator_user_id uuid,
	current_state_at bigint,
	current_state_value real,
	current_state_stability smallint,
	current_state_originator_user_id uuid
);

COMMIT;
