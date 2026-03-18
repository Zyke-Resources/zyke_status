-- Server-side sound bridge for the reaction system
-- Handles sound playback requests from the client via zyke_sounds

local hasSounds = GetResourceState("zyke_sounds") == "started" or GetResourceState("zyke_sounds") == "starting"

---@type table<string, { name: string | string[] | { male: string | string[], female: string | string[] }, volume: number, distance: number }>
local soundRegistry = {}

---@type table<integer, table<string, string>> @ [playerId][queueId] = soundId
local activeSounds = {}

---@type table<integer, integer> @ [playerId] = last reaction timestamp (ms)
local lastReactionTime = {}

local rateLimitMs = 500

-- Build the sound registry from all Config.Status threshold effects
-- queueIds in the effect_manager follow the pattern: "statusType.subName;thresholdIdx"
-- For non-multi statuses, the secondary can default to the primary name (ex. stress.stress instead of stress.base)
local function buildSoundRegistry()
    for statusType, statusSettings in pairs(Config.Status) do
        for subName, subConfig in pairs(statusSettings) do
            if (subConfig.effect) then
                for thresholdIdx, thresholdConfig in ipairs(subConfig.effect) do
                    if (thresholdConfig.reaction and thresholdConfig.reaction.sound) then
                        -- Register with the config key (ex. "stress.base;1")
                        local queueId = statusType .. "." .. subName .. ";" .. thresholdIdx
                        soundRegistry[queueId] = thresholdConfig.reaction.sound

                        -- Also register with statusType as secondary (ex. "stress.stress;1")
                        -- Non-multi statuses default secondary to primary name
                        if (subName ~= statusType) then
                            local altQueueId = statusType .. "." .. statusType .. ";" .. thresholdIdx
                            soundRegistry[altQueueId] = thresholdConfig.reaction.sound
                        end
                    end
                end
            end
        end
    end

    local count = 0

    for k in pairs(soundRegistry) do
        count = count + 1
        Z.debug("Reaction sound registry:", k)
    end

    Z.debug("Reaction sound registry built with " .. count .. " entries.")
end

buildSoundRegistry()

---@param soundConfig { name: string | string[] | { male: string | string[], female: string | string[] }, volume: number, distance: number }
---@param gender string? @ "male" or "female"
---@return string? @ resolved file name
local function resolveSoundFile(soundConfig, gender)
    local name = soundConfig.name

    -- Gender-specific: table with male/female keys
    if (type(name) == "table" and (name.male ~= nil or name.female ~= nil)) then
        local genderFiles = name[gender or "male"]
        if (genderFiles == nil) then
            genderFiles = name.male or name.female
        end

        if (type(genderFiles) == "table") then
            return genderFiles[math.random(#genderFiles)]
        else
            return genderFiles
        end
    end

    -- Array of sound names (random pick)
    if (type(name) == "table") then
        return name[math.random(#name)]
    end

    -- Simple string
    return name
end

---@param source integer
---@param queueId string
---@return string
local function getSoundId(source, queueId)
    return "zyke_status_reaction:" .. source .. ":" .. queueId
end

-- Callback: client requests sound start
-- Returns true on success so the client knows when to play the animation
Z.callback.register("zyke_status:ReactionSound", function(plyId, queueId, action)
    if (not hasSounds) then return false end
    if (type(queueId) ~= "string") then return false end
    if (action ~= "start") then return false end

    -- Validate against registry
    local soundConfig = soundRegistry[queueId]
    if (not soundConfig) then
        Z.debug("^1[zyke_status] Rejected reaction sound request from " .. tostring(plyId) .. " — unregistered queueId: " .. tostring(queueId) .. "^7")
        return false
    end

    -- Rate limiting
    local now = GetGameTimer()
    if (lastReactionTime[plyId] and (now - lastReactionTime[plyId]) < rateLimitMs) then
        return false
    end

    lastReactionTime[plyId] = now

    -- Resolve gender and sound file
    local gender = Z.getGender(plyId)
    local soundFile = resolveSoundFile(soundConfig, gender)
    if (not soundFile or soundFile == "") then return false end

    -- Build sound ID and play
    local soundId = getSoundId(plyId, queueId)
    local plyPed = GetPlayerPed(plyId)

    exports["zyke_sounds"]:PlaySoundOnEntity(plyPed, soundId, soundFile, soundConfig.volume, soundConfig.distance, false, 1)

    -- Track active sound
    if (not activeSounds[plyId]) then activeSounds[plyId] = {} end

    activeSounds[plyId][queueId] = soundId

    return true
end)

-- Event: client requests sound stop (fire-and-forget, no callback needed)
RegisterNetEvent("zyke_status:StopReactionSound", function(queueId)
    local plyId = source

    if (not hasSounds) then return end
    if (type(queueId) ~= "string") then return end

    -- Check if this player actually has an active sound for this queueId
    if (not activeSounds[plyId] or not activeSounds[plyId][queueId]) then return end

    local soundId = activeSounds[plyId][queueId]
    exports["zyke_sounds"]:StopSound(soundId)
    activeSounds[plyId][queueId] = nil
end)

-- Cleanup on character logout
RegisterNetEvent("zyke_lib:OnCharacterLogout", function()
    local plyId = source

    if (activeSounds[plyId]) then
        if (hasSounds) then
            for queueId, soundId in pairs(activeSounds[plyId]) do
                exports["zyke_sounds"]:StopSound(soundId)
            end
        end

        activeSounds[plyId] = nil
    end

    lastReactionTime[plyId] = nil
end)

-- Cleanup on player drop
AddEventHandler("playerDropped", function()
    local plyId = source

    if (activeSounds[plyId]) then
        if (hasSounds) then
            for queueId, soundId in pairs(activeSounds[plyId]) do
                exports["zyke_sounds"]:StopSound(soundId)
            end
        end

        activeSounds[plyId] = nil
    end

    lastReactionTime[plyId] = nil
end)
