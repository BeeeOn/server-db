-- beeeon-server, pg

BEGIN;

CREATE SCHEMA beeeon;

CREATE OR REPLACE FUNCTION beeeon.always_fail(reason text)
RETURNS VOID AS
$$
BEGIN
	RAISE EXCEPTION '%', reason;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION beeeon.assure_true(result bool, reason text)
RETURNS VOID AS
$$
BEGIN
	IF NOT result THEN
		RAISE EXCEPTION '%', reason;
	END IF;
END;
$$ LANGUAGE plpgsql;

-- helper for verify scripts
CREATE OR REPLACE FUNCTION beeeon.assure_function(
	ns text,
	spec text
)
RETURNS BOOLEAN AS
$$
	SELECT has_function_privilege(
		ns || '.' || spec,
		'execute'
	);
$$ LANGUAGE SQL;

-- helper for verify scripts
CREATE OR REPLACE FUNCTION beeeon.assure_type(
	ns   text,
	name text
)
RETURNS bigint AS
$$
	SELECT 1 / COUNT(*)
		FROM pg_catalog.pg_type t
		JOIN pg_catalog.pg_namespace n ON t.typnamespace = n.oid
		WHERE t.typisdefined
			AND n.nspname = ns
			AND t.typname = name;
$$ LANGUAGE SQL;

COMMIT;
