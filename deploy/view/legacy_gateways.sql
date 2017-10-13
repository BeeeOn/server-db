-- beeeon-server, pg

BEGIN;

CREATE VIEW beeeon.legacy_gateways AS
SELECT
	g.id AS id,
	g.name AS name,
	g.altitude AS altitude,
	g.latitude AS latitude,
	g.longitude AS longitude,
	(SELECT COUNT(*) FROM beeeon.roles_in_gateway AS r
		WHERE r.gateway_id = g.id)
	AS roles_count,
	(SELECT COUNT(*) FROM beeeon.devices AS d
		WHERE d.gateway_id = g.id AND d.active_since IS NOT NULL)
	AS devices_count,
	(SELECT user_id FROM beeeon.verified_identities AS v
		JOIN beeeon.roles_in_gateway AS r
			ON r.identity_id = v.identity_id
		WHERE r.level <= 10 AND r.gateway_id = g.id ORDER BY r.created ASC LIMIT 1)
	AS owner_id
	FROM beeeon.gateways AS g;

GRANT SELECT
	ON TABLE beeeon.legacy_gateways
	TO beeeon_user;

COMMIT;
