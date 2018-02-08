-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.roles_in_gateway_remove_user(_user_id uuid, _gateway_id bigint);

COMMIT;
