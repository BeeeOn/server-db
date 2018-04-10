SET search_path TO beeeon, public;

\set query_raw `cat pgsql/sensors_history/huge_fetch_raw.sql`

BEGIN;

\ir ../_common.sql
\ir _prepare_sensors.sql

PREPARE huge_fetch_raw AS :query_raw;

DO LANGUAGE plpgsql
$$
DECLARE
	rec record;
	q text;
	periods interval[] := ARRAY[
		interval '1 hour',
		interval '6 hours',
		interval '1 day',
		interval '7 days',
		interval '14 days',
		interval '30 days'];
	period interval;
BEGIN
	FOR rec IN (SELECT * FROM candidate_sensors) LOOP
		FOREACH period IN ARRAY periods LOOP
			q := format(
				'EXECUTE huge_fetch_raw('
					'%s, %s, %s, %s, %s)',
				rec.gateway_id,
				beeeon.from_device_id(rec.device_id),
				rec.module_id,
				extract(epoch FROM rec.at_max - period),
				extract(epoch FROM rec.at_max));

			PERFORM explain_analyze(q);
		END LOOP;
	END LOOP;
END;
$$;

ROLLBACK;
