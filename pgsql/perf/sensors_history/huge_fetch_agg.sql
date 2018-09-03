SET search_path TO beeeon, public;

\set query `cat queries/sensors_history/huge_fetch_agg.sql`

BEGIN;

\ir ../_common.sql
\ir _prepare_sensors.sql

PREPARE huge_fetch_agg AS :query;

DO LANGUAGE plpgsql
$$
DECLARE
	rec record;
	q text;
	periods interval[] := ARRAY[
		interval '1 day',
		interval '7 days',
		interval '14 days'];
	period interval;
	steps integer[] := ARRAY[30, 60, 300, 600, 3600, 86400];
	step integer;
BEGIN
	FOR rec IN (SELECT * FROM candidate_sensors) LOOP
		FOREACH period IN ARRAY periods LOOP
			FOREACH step IN ARRAY steps LOOP
				q := format(
					'EXECUTE huge_fetch_agg('
						'%s, %s, %s, %s, %s, %s)',
					rec.gateway_id,
					beeeon.from_device_id(rec.device_id),
					rec.module_id,
					extract(epoch FROM rec.at_max - period),
					extract(epoch FROM rec.at_max),
					step);

				PERFORM explain_analyze(q);
			END LOOP;
		END LOOP;
	END LOOP;
END;
$$;

ROLLBACK;
