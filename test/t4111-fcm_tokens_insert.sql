SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(5);

SELECT has_function('fcm_tokens_insert');

SELECT throws_ok(
	$$ SELECT fcm_tokens_insert(
		'cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5',
		'608aad61-5665-482a-918d-098a35602520'
	) $$,
	23503,
	NULL,
	'no such user'
);

INSERT INTO users (id, first_name, last_name, locale)
VALUES ('608aad61-5665-482a-918d-098a35602520', 'Franta', 'Bubak', 'cs_CZ');

SELECT lives_ok(
	$$ SELECT fcm_tokens_insert(
		'cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5',
		'608aad61-5665-482a-918d-098a35602520'
	) $$,
	'no reason to fail on constraints'
);

SELECT ok(EXISTS(
	SELECT 1 FROM beeeon.fcm_tokens
	WHERE
		token = 'cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5'
		AND
		user_id = '608aad61-5665-482a-918d-098a35602520'
	),
	'token of user 608aad61-5665-482a-918d-098a35602520 should have been inserted'
);

SELECT throws_ok(
	$$ SELECT fcm_tokens_insert(
		'cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5',
		'608aad61-5665-482a-918d-098a35602520'
	) $$,
	23505,
	NULL,
	'primary key violation when creating the same token twice'
);

SELECT finish();
ROLLBACK;
