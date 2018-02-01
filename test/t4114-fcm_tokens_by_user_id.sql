SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/fcm_tokens.fetch_by_user_id.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION fcm_tokens_by_user_id(uuid)
RETURNS SETOF beeeon.fcm_tokens AS :query LANGUAGE SQL;

SELECT plan(2);

SELECT is_empty(
	$$ SELECT * FROM fcm_tokens_by_user_id('8c3e5613-7692-4915-951d-68362505e4ce') $$,
	'must be empty, there is no token yet'
);

INSERT INTO users (id, first_name, last_name, locale)
VALUES ('608aad61-5665-482a-918d-098a35602520', 'Franta', 'Bubak', 'cs_CZ');

INSERT INTO fcm_tokens (token, user_id)
VALUES ('cdnvrVdlLzI:'
	'APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-'
	'ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5',
	'608aad61-5665-482a-918d-098a35602520');

SELECT results_eq(
	$$ SELECT * FROM fcm_tokens_by_user_id('608aad61-5665-482a-918d-098a35602520') $$,
	$$ VALUES (
		'cdnvrVdlLzI:'
		'APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-'
		'ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5'::varchar(250),
		'608aad61-5665-482a-918d-098a35602520'::uuid
	) $$,
	'fcm_token of user with id 608aad61-5665-482a-918d-098a35602520 should have been created'
);

SELECT finish();
ROLLBACK;
