SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/fcm_tokens.fetch_by_id.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION fcm_tokens_by_id(varchar)
RETURNS SETOF beeeon.fcm_token AS :query LANGUAGE SQL;

SELECT plan(1);

INSERT INTO users (id, first_name, last_name, locale)
VALUES ('608aad61-5665-482a-918d-098a35602520', 'Franta', 'Bubak', 'cs_CZ');

INSERT INTO fcm_tokens (token, user_id)
VALUES ('adnvrVdlLzI:'
	'APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-'
	'ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5',
	'608aad61-5665-482a-918d-098a35602520');

SELECT results_eq(
	$$ SELECT * FROM fcm_tokens_by_id(
		'adnvrVdlLzI:'
		'APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-'
		'ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5') $$,
	$$ VALUES (
		'adnvrVdlLzI:'
		'APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-'
		'ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5'::varchar(250),
		'608aad61-5665-482a-918d-098a35602520'::uuid,
		'Franta'::varchar(250),
		'Bubak'::varchar(250),
		'cs_CZ'::varchar(250)
	) $$,
	'user with id 608aad61-5665-482a-918d-098a35602520 should be found by fcm token'
);

SELECT finish();
ROLLBACK;
