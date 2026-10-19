---@type ClientCache
Cache = {
    statuses = nil,
    directEffects = nil,
    directEffectsTotalDuration = nil,
    statusFrozen = true
}

-- List of functions for effects
-- Indexed by primary.secondary
EffectFunctions = {}

local function init()
    Z.debug("[Init] Fetching player status and direct effects.")

    Cache.statusFrozen = true
    Cache.statuses = Z.callback.await("zyke_status:GetPlayerStatus")
    Cache.directEffects, Cache.directEffectsTotalDuration = Z.callback.await("zyke_status:GetPlayerDirectEffects")
    Cache.statusFrozen = Z.callback.await("zyke_status:IsPlayerFrozen")

    if (Cache.statusFrozen) then
        TriggerEvent("zyke_status:OnPlayerStatusFrozen")
        Z.debug("[Init] Status fetched while frozen.")

        return
    end

    TriggerEvent("zyke_status:OnDirectEffectsUpdated", Cache.directEffects, {}, Cache.directEffectsTotalDuration)
    Z.debug("[Init] Status fetched successfully.")
    TriggerEvent("zyke_status:OnStatusFetched")
end

AddEventHandler("zyke_lib:OnCharacterSelect", function()
    init()
end)

RegisterNetEvent("zyke_status:HasInitialized", function()
    init()
end)

RegisterNetEvent("zyke_lib:OnLoaderFinished", function()
    while not (LocalPlayer.state["z:hasLoaded"]) do
        Wait(100)
    end

    if (Cache.statuses ~= nil) then return end

    init()
end)

RegisterNetEvent("zyke_status:OnPlayerStatusUnfrozen", function()
    Cache.statusFrozen = false
    init()
end)