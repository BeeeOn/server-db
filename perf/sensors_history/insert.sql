SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat pgsql/sensors_history/insert.sql`

BEGIN;

\ir ../_common.sql
\ir _prepare_sensors.sql

PREPARE query_insert AS :query;

DO LANGUAGE plpgsql
$$
DECLARE
	rec record;
	q text;
	t bigint;
BEGIN
	FOR rec IN (SELECT * FROM candidate_sensors) LOOP
		FOR i IN 1..10 LOOP
			t := extract(epoch from beeeon.now_utc())::bigint;
			q := format(
				'EXECUTE query_insert(%s, %s, %s, %s, %s)',
				rec.gateway_id,
				beeeon.from_device_id(rec.device_id),
				rec.module_id,
				t + i,
				15.5 + i);

			PERFORM explain_analyze(q);
		END LOOP;
	END LOOP;
END;
$$;

ROLLBACK;

ROLLBACK;
