-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_insert(
	_id uuid,
	_gateway_id bigint,
	_identity_id uuid,
	_level integer,
	_created bigint
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.roles_in_gateway (
		id,
		gateway_id,
		identity_id,
		level,
		created
	)
	VALUES (
		_id,
		_gateway_id,
		_identity_id,
		_level,
		to_timestamp(_created)
	);
$$ LANGUAGE SQL;

COMMIT;
