-- Rounds to the configured accuracy and keeps the value within 0.0-100.0
---@param value number
---@return number
function ClampStatusValue(value)
    value = Z.numbers.round(value, Config.Settings.decimalAccuracy)

    return math.max(0.0, math.min(100.0, value))
end

-- Default hooks for a status holding one `value` from 0 to 100, draining by its configured `value.drain`
-- A status resting at 0 (drunk, high) is removed once emptied, one starting full (hunger) stays at 0
---@param name StatusName
---@param baseValues table
---@return StatusFunctions
local function createDefaultFunctions(name, baseValues)
    local restsAtZero = (baseValues.value or 0.0) <= 0.0

    ---@param plyId PlayerId
    ---@param statusNames StatusNames
    ---@return table<SecondaryName, PlayerStatus> | nil, SecondaryName
    local function getValues(plyId, statusNames)
        local data = GetPlayerBaseStatusTable(plyId, name)

        return data and data.values, statusNames[2] or name
    end

    return {
        onTick = function(players)
            for i = 1, #players do
                local plyId, statuses = players[i][1], players[i][2]

                for j = 1, #statuses do
                    local secondary, multiplier = statuses[j][1], statuses[j][2]
                    local settings = GetStatusSettings(name, secondary)
                    local amount = (settings?.value?.drain or 0) * multiplier

                    if (amount > 0.0) then
                        RemoveFromStatus(plyId, {name, secondary}, amount, true)
                    end
                end
            end
        end,
        onAdd = function(plyId, statusNames, amount)
            local values, secondary = getValues(plyId, statusNames)
            if (not values) then return end

            values[secondary].value = ClampStatusValue(values[secondary].value + amount)

            return true
        end,
        onRemove = function(plyId, statusNames, amount)
            local values, secondary = getValues(plyId, statusNames)
            if (not values) then return end

            local value = ClampStatusValue(values[secondary].value - amount)

            if (value <= 0.0 and restsAtZero) then
                values[secondary] = nil
            else
                values[secondary].value = value
            end

            return true
        end,
        onSet = function(plyId, statusNames, amount)
            local values, secondary = getValues(plyId, statusNames)
            if (not values) then return end

            local value = ClampStatusValue(amount)
            values[secondary].value = value

            return true, value
        end,
        onReset = function(plyId, statusNames)
            local values, secondary = getValues(plyId, statusNames)
            if (not values) then return end

            if (restsAtZero) then
                values[secondary] = nil
            else
                values[secondary].value = baseValues.value
            end

            return true
        end
    }
end

-- Registers a status type from statuses/registry.lua, which will allow a status object for this type to be created
-- Every hook falls back to the defaults above, pass a function to override one or false to disable onTick/onSet
---@param name StatusName
---@param functions? StatusFunctions
function RegisterStatusType(name, functions)
    local statusType = StatusTypes[name]
    local multi = statusType.multi == true

    Z.debug("Registering: " .. name .. ", multi: " .. tostring(multi))

    -- Values every entry of this status is required to have
    local baseValues = {value = statusType.reversed and 100.0 or 0.0}
    for key, value in pairs(statusType.values or {}) do
        baseValues[key] = value
    end

    local hooks = createDefaultFunctions(name, baseValues)
    for hookName, fn in pairs(functions or {}) do
        hooks[hookName] = fn
    end

    local subStatuses = {}
    for subName in pairs(Config.Status[name]) do
        subStatuses[subName] = true
    end

    Cache.existingStatuses[name] = {
        multi = multi,
        baseValues = baseValues,
        onTick = hooks.onTick or nil,
        onAdd = hooks.onAdd,
        onRemove = hooks.onRemove,
        onSet = hooks.onSet or nil,
        onReset = hooks.onReset,
        onSoftReset = hooks.onSoftReset,
        subStatuses = subStatuses
    }

    PopulateStatusTimeout(name)
end

local existingStatuses = Cache.existingStatuses

-- Ensuring all of the substatuses, so that we can track them
-- Executed on fn EnsurePlayerSubStatus, which means it is ensured when a status is being ensured
---@param primary PrimaryName
---@param secondary SecondaryName
function EnsureSubStatus(primary, secondary)
    local _existing = existingStatuses[primary]
    if (_existing == nil) then return end

    local subStatuses = _existing.subStatuses
    if (subStatuses[secondary]) then return end

    subStatuses[secondary] = true
    PopulateStatusTimeout(primary)
end

-- Ensures all of the sub statuses for a player
-- Because of our dynamic approach, your character might have statuses no one else has, and not has not yet cached them
-- So on character load, we cache these existing statuses
---@param plyId PlayerId
function EnsurePlayerSubStatusesCache(plyId)
    local plyStatuses = Cache.statuses[plyId]
    for primary, subStatuses in pairs(plyStatuses) do
        for secondary in pairs(subStatuses.values) do
            EnsureSubStatus(primary, secondary)
        end
    end
end