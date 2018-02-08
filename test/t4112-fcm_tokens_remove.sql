SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat pgsql/fcm_tokens/remove.sql`

BEGIN;

PREPARE fcm_tokens_remove(varchar)
AS :query;

SELECT plan(3);

SELECT lives_ok(
	$$ EXECUTE fcm_tokens_remove('cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5') $$,
	'removing of non-existing verified identity should not fail'
);

INSERT INTO users (id, first_name, last_name, locale)
VALUES ('608aad61-5665-482a-918d-098a35602520', 'Franta', 'Bubak', 'cs_CZ');

INSERT INTO fcm_tokens (token, user_id)
VALUES ('cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5', 
	'608aad61-5665-482a-918d-098a35602520');

SELECT lives_ok(
	$$ EXECUTE fcm_tokens_remove(
		'cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5'
	) $$,
	'no reason to fail to remove'
);

SELECT ok(NOT EXISTS(
	SELECT 1 FROM beeeon.fcm_tokens
	WHERE
		token = 'cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5'
		AND
		user_id = '608aad61-5665-482a-918d-098a35602520'
	),
	'token of user 608aad61-5665-482a-918d-098a35602520 should no longer exist'
);

SELECT finish();
ROLLBACK;
