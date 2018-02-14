-- beeeon-server, pg

BEGIN;

---
-- Convert a number to device ID as represented in the type device.
-- The representation is bigint that is a signed 64-bit value. Thus,
-- all unsigned numbers that overflow 63-bits wide data types must
-- be converted manually by this method.
---
CREATE OR REPLACE FUNCTION beeeon.to_device_id(num numeric(20, 0))
RETURNS bigint AS
$$
BEGIN
	IF num < 0 OR num >= 18446744073709551616 THEN
		RAISE EXCEPTION 'device ID is out of bounds: %', num;
	ELSIF num <= 9223372036854775807 THEN
		RETURN num::bigint;
	ELSE
		RETURN (num - 18446744073709551616)::bigint;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION beeeon.to_device_id(num varchar(20))
RETURNS bigint AS
$$
DECLARE
	tmp numeric(20, 0);
BEGIN
	tmp := to_number(num, '99999999999999999999');
	RETURN beeeon.to_device_id(tmp);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION beeeon.to_device_id(num bigint)
RETURNS bigint AS
$$
BEGIN
	RETURN num;
END;
$$ LANGUAGE plpgsql;

---
-- Convert a number to device ID as represented in the type device.
-- The representation is bigint that is a signed 64-bit value. Thus,
-- all unsigned numbers that overflow 63-bits wide data types must
-- be converted manually by this method.
---
CREATE OR REPLACE FUNCTION beeeon.from_device_id(id bigint)
RETURNS varchar(20) AS
$$
BEGIN
	IF id IS NULL THEN
		RETURN NULL;
	ELSIF id < 0 THEN
		RETURN to_char(id::numeric + 18446744073709551616, 'FM99999999999999999999');
	ELSE
		RETURN to_char(id::numeric, 'FM99999999999999999999');
	END IF;
END;
$$ LANGUAGE plpgsql;

COMMIT;
