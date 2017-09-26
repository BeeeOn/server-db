-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.control_stability AS ENUM (
	'unknown',
	'requested',
	'accepted',
	'unconfirmed',
	'confirmed',
	'overriden',
	'stuck',
	'failed_rollback',
	'failed_unknown'
);

---
-- Convert from the application ABI to the control_stability enum.
---
CREATE OR REPLACE FUNCTION beeeon.to_control_stability(s smallint)
RETURNS beeeon.control_stability AS
$$
BEGIN
	CASE s
	WHEN 0 THEN
		RETURN 'unknown';
	WHEN 1 THEN
		RETURN 'requested';
	WHEN 2 THEN
		RETURN 'accepted';
	WHEN 3 THEN
		RETURN 'unconfirmed';
	WHEN 4 THEN
		RETURN 'confirmed';
	WHEN 5 THEN
		RETURN 'overriden';
	WHEN 6 THEN
		RETURN 'stuck';
	WHEN 7 THEN
		RETURN 'failed_rollback';
	WHEN 8 THEN
		RETURN 'failed_unknown';
	ELSE
		RAISE EXCEPTION 'control stability out of bounds: %', s;
	END CASE;
END;
$$ LANGUAGE plpgsql;

---
-- Syntax sugar to avoid unnecessary '::smallint' in calls.
---
CREATE OR REPLACE FUNCTION beeeon.to_control_stability(s integer)
RETURNS beeeon.control_stability AS
$$
BEGIN
	RETURN to_control_stability(s::smallint);
END;
$$ LANGUAGE plpgsql;

---
-- Convert from the control_stability enum to the application ABI.
---
CREATE OR REPLACE FUNCTION beeeon.from_control_stability(s beeeon.control_stability)
RETURNS smallint AS
$$
BEGIN
	IF s IS NULL THEN
		RETURN NULL;
	END IF;

	CASE s
	WHEN 'unknown' THEN
		RETURN 0;
	WHEN 'requested' THEN
		RETURN 1;
	WHEN 'accepted' THEN
		RETURN 2;
	WHEN 'unconfirmed' THEN
		RETURN 3;
	WHEN 'confirmed' THEN
		RETURN 4;
	WHEN 'overriden' THEN
		RETURN 5;
	WHEN 'stuck' THEN
		RETURN 6;
	WHEN 'failed_rollback' THEN
		RETURN 7;
	WHEN 'failed_unknown' THEN
		RETURN 8;
	ELSE
		RAISE EXCEPTION 'unrecognized control stability: %', s;
	END CASE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION beeeon.control_stability_is_confirmed(s beeeon.control_stability)
RETURNS bool AS
$$
BEGIN
	CASE s
	WHEN 'confirmed' THEN
		RETURN TRUE;
	WHEN 'overriden' THEN
		RETURN TRUE;
	WHEN 'stuck' THEN
		RETURN TRUE;
	WHEN 'failed_rollback' THEN
		RETURN TRUE;
	WHEN 'failed_unknown' THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END CASE;
END;
$$ LANGUAGE plpgsql;

COMMIT;
