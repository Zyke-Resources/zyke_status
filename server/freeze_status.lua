-- Freezes status processing while preserving the state per character
-- Frozen characters keep their cached values and resume when explicitly unfrozen

---@class FrozenPlayer
---@field plyId PlayerId
---@field identifier CharacterIdentifier
---@field frozenAt OsTime

---@type table<PlayerId, FrozenPlayer>
local frozenPlayers = {}

---@type table<PlayerId, CharacterIdentifier>
local loadedPlayerIdentifiers = {}

---@param plyId PlayerId
---@param notifyClient boolean
local function clearPlayerFreezeStatus(plyId, notifyClient)
	if (not frozenPlayers[plyId]) then return end

	frozenPlayers[plyId] = nil

	if (notifyClient) then
		TriggerClientEvent("zyke_status:OnPlayerStatusUnfrozen", plyId)
	end

	TriggerEvent("zyke_status:OnPlayerStatusUnfrozen", plyId)
	Z.debug("Unfroze status for", plyId)
end

---@param plyId PlayerId
---@param identifier CharacterIdentifier
---@param notifyClient boolean
local function applyPlayerFreezeStatus(plyId, identifier, notifyClient)
	local frozenPlayer = frozenPlayers[plyId]
	if (frozenPlayer and frozenPlayer.identifier == identifier) then return end

	if (frozenPlayer) then
		clearPlayerFreezeStatus(plyId, false)
	end

	frozenPlayers[plyId] = {
		plyId = plyId,
		identifier = identifier,
		frozenAt = os.time()
	}

	if (notifyClient) then
		TriggerClientEvent("zyke_status:OnPlayerStatusFrozen", plyId)
	end

	TriggerEvent("zyke_status:OnPlayerStatusFrozen", plyId)
	Z.debug("Froze status for", plyId)
end

---@param plyId PlayerId
function FreezeStatus(plyId)
	local identifier = Z.getIdentifier(plyId)
	if (not identifier) then return end

	local frozenPlayer = frozenPlayers[plyId]
	if (frozenPlayer and frozenPlayer.identifier == identifier) then return end

	MySQL.query.await("INSERT INTO zyke_status (identifier, frozen) VALUES (?, TRUE) ON DUPLICATE KEY UPDATE frozen = TRUE", {identifier})
	loadedPlayerIdentifiers[plyId] = identifier
	applyPlayerFreezeStatus(plyId, identifier, true)
end

---@param plyId PlayerId
function UnfreezeStatus(plyId)
	local identifier = Z.getIdentifier(plyId)
	if (not identifier) then return end

	local frozenPlayer = frozenPlayers[plyId]
	if (frozenPlayer and identifier ~= frozenPlayer.identifier) then
		clearPlayerFreezeStatus(plyId, true)
	end

	MySQL.update.await("UPDATE zyke_status SET frozen = FALSE WHERE identifier = ?", {identifier})
	loadedPlayerIdentifiers[plyId] = identifier
	clearPlayerFreezeStatus(plyId, true)
end

---@param plyId PlayerId
---@return boolean isFrozen
function RestorePlayerFreezeStatus(plyId)
	local identifier = Z.getIdentifier(plyId)
	if (not identifier) then
		loadedPlayerIdentifiers[plyId] = nil
		clearPlayerFreezeStatus(plyId, false)

		return false
	end

	local frozenPlayer = frozenPlayers[plyId]
	if (frozenPlayer and frozenPlayer.identifier ~= identifier) then
		clearPlayerFreezeStatus(plyId, false)
	end

	if (loadedPlayerIdentifiers[plyId] == identifier) then
		return frozenPlayers[plyId] ~= nil
	end

	local frozen = MySQL.scalar.await("SELECT frozen FROM zyke_status WHERE identifier = ?", {identifier})
	if (Z.getIdentifier(plyId) ~= identifier) then return false end

	loadedPlayerIdentifiers[plyId] = identifier
	if (frozen == true or frozen == 1 or frozen == "1") then
		applyPlayerFreezeStatus(plyId, identifier, false)

		return true
	end

	clearPlayerFreezeStatus(plyId, false)

	return false
end

---@return table<PlayerId, FrozenPlayer> frozenPlayers
function GetFrozenPlayers()
	return frozenPlayers
end

---@param plyId PlayerId
---@return boolean isFrozen
function IsPlayerFrozen(plyId)
	return frozenPlayers[plyId] ~= nil
end

---@param plyId PlayerId
---@return boolean isFrozen
Z.callback.register("zyke_status:IsPlayerFrozen", function(plyId)
	return RestorePlayerFreezeStatus(plyId)
end)

---@param plyId PlayerId
AddEventHandler("zyke_lib:OnCharacterLogout", function(plyId)
	loadedPlayerIdentifiers[plyId] = nil
	clearPlayerFreezeStatus(plyId, false)
end)

AddEventHandler("playerDropped", function()
	local plyId = source
	loadedPlayerIdentifiers[plyId] = nil
	clearPlayerFreezeStatus(plyId, false)
end)

exports("FreezeStatus", FreezeStatus)
exports("UnfreezeStatus", UnfreezeStatus)
exports("GetFrozenPlayers", GetFrozenPlayers)
exports("IsPlayerFrozen", IsPlayerFrozen)