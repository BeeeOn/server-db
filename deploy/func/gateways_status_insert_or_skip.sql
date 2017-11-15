-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.gateways_status_insert_or_skip(
	_gateway_id bigint,
	_at bigint,
	_version varchar(40),
	_ip varchar(45)
)
RETURNS VOID AS
$$
DECLARE
	count bigint;
BEGIN
	SELECT COUNT(*) FROM beeeon.gateways_status
	INTO count
	WHERE
		gateway_id = _gateway_id
		AND
		version = _version
		AND
		ip = _ip::inet
		AND
		at = beeeon.gateways_status_most_recent(_gateway_id);
	
	IF count = 0 THEN
		INSERT INTO beeeon.gateways_status (gateway_id, at, version, ip)
		VALUES (
			_gateway_id,
			beeeon.as_utc_timestamp(_at),
			_version,
			_ip::inet
		);
	END IF;
END;
$$ LANGUAGE plpgsql;

COMMIT;
