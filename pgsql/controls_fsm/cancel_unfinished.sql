UPDATE
	beeeon.controls_fsm
SET
	finished_at = beeeon.now_utc(),
	failed = true
WHERE
	finished_at IS NULL
