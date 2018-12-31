---
-- Delete the selected message. The condition for gateway_id
-- is in fact redundant but it can prevent a bug at the application
-- layer when it is less probable that somebody would delete
-- a message without the appropriate permissions.
---
DELETE
FROM
	beeeon.gateways_messages
WHERE
	id = $1::uuid
	AND
	gateway_id = $2::bigint
