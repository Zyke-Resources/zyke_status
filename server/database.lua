QueriesExecuted = false

local queries = {
	[[
		CREATE TABLE IF NOT EXISTS `zyke_status` (
			`identifier` VARCHAR(255) NOT NULL,
			`data` MEDIUMTEXT NOT NULL DEFAULT "{}",
			`direct_effects` MEDIUMTEXT NOT NULL DEFAULT "{}",
			`frozen` BOOLEAN NOT NULL DEFAULT FALSE,
			UNIQUE (`identifier`)
		);
	]]
}

local totalQueries = #queries
for i = 1, #queries do
	MySQL.query.await(queries[i])
	Z.debug("^3Executed query: " .. i .. "/" .. totalQueries .. ".^7")
end

-- Tables created before freezing was persisted lack the column, MySQL has no ADD COLUMN IF NOT EXISTS
local hasFrozenColumn = MySQL.scalar.await("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'zyke_status' AND COLUMN_NAME = 'frozen'") > 0
if (not hasFrozenColumn) then
	MySQL.query.await("ALTER TABLE `zyke_status` ADD COLUMN `frozen` BOOLEAN NOT NULL DEFAULT FALSE")
	Z.debug("^3Added frozen column to zyke_status.^7")
end

Z.debug("^2Database initialized successfully.^7")

QueriesExecuted = true