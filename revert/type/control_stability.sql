-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.control_stability_is_confirmed(beeeon.control_stability);
DROP FUNCTION beeeon.from_control_stability(beeeon.control_stability);
DROP FUNCTION beeeon.to_control_stability(integer);
DROP FUNCTION beeeon.to_control_stability(smallint);
DROP TYPE beeeon.control_stability;

COMMIT;
