-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.gateways_status_most_recent(
	_gateway_id bigint
)
RETURNS timestamp AS
$$
DECLARE
	last_at timestamp;
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM beeeon.gateways_status WHERE gateway_id = _gateway_id
	) THEN
		RETURN NULL;
	END IF;

	SELECT MAX(at)
		INTO last_at
		FROM beeeon.gateways_status
		WHERE gateway_id = _gateway_id;

	RETURN last_at;
END;
$$ LANGUAGE plpgsql;

COMMIT;
