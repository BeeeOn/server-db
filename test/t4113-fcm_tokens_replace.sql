SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ BEGIN '`cat pgsql/fcm_tokens/replace.sql`; 'RETURN FOUND; END;' $$

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.fcm_tokens_replace(varchar, varchar)
RETURNS boolean AS :query LANGUAGE plpgsql;

SELECT plan(4);

SELECT ok(
	NOT fcm_tokens_replace(
	'cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5', 
	'asN32L-lLas:qww9cx12K32ZDhdoLlbzF031YHFf7MrEV42oN3OaeiYR0qweDEEr7us-eraJRQYdASDmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5'),
	'nothing to replace, expect false'
);

INSERT INTO users (id, first_name, last_name, locale)
VALUES ('608aad61-5665-482a-918d-098a35602520', 'Franta', 'Bubak', 'cs_CZ');

INSERT INTO fcm_tokens (token, user_id)
VALUES ('cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5',
	'608aad61-5665-482a-918d-098a35602520');

SELECT ok(fcm_tokens_replace(
	'cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5', 
	'asN32L-lLas:qww9cx12K32ZDhdoLlbzF031YHFf7MrEV42oN3OaeiYR0qweDEEr7us-eraJRQYdASDmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5'),
	'token should be replaces'
);

SELECT ok(NOT EXISTS(
	SELECT 1 FROM beeeon.fcm_tokens
	WHERE
		token = 'cdnvrVdlLzI:APA91bGsKYSZDhdoLlbzF0XSYHFf7MrEV7YoN3OsGiYR0EURDEEr7uG-ePiJRQYMi9LmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5'
		AND
		user_id = '608aad61-5665-482a-918d-098a35602520'
	),
	'old token of user 608aad61-5665-482a-918d-098a35602520 should not exist anymore'
);

SELECT ok(EXISTS(
	SELECT 1 FROM beeeon.fcm_tokens
	WHERE
		token = 'asN32L-lLas:qww9cx12K32ZDhdoLlbzF031YHFf7MrEV42oN3OaeiYR0qweDEEr7us-eraJRQYdASDmLrzBwIJBphVaCZdcAKlJCE6uckwsYcTMpjVoNN7yQN2BPdvnNGGRJin6oHWJjfSMMiDvMAE5'
		AND
		user_id = '608aad61-5665-482a-918d-098a35602520'
	),
	'new token of user 608aad61-5665-482a-918d-098a35602520 should exist'
);

SELECT finish();
ROLLBACK;
