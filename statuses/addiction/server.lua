-- Addiction has two values, the satisfaction level `value` and your addiction level `addiction`

-- Addiction `addiction`:
--- Moves up when using the substance and down when removing from the status
--- Below the addiction threshold it drains by itself, so minor use wears off
--- At or above the threshold it is static, you are addicted until something treats it by removing from the status

-- Satisfaction `value`
--- Stays at 100 while you are not addicted
--- Once you are addicted, it keeps draining, and low levels trigger the withdrawal effects
--- Using the substance restores it, heals & revives reset it without touching the addiction

local primary = "addiction"

---@param entry AddictionStatus
---@param settings table
---@return boolean
local function pastThreshold(entry, settings)
    return entry.addiction >= settings.addiction.threshold
end

---@param plyId PlayerId
---@param statusNames StatusNames
---@return table<SecondaryName, AddictionStatus> | nil, SecondaryName, table
local function getEntry(plyId, statusNames)
    local secondary = statusNames[2] or primary
    local data = GetPlayerBaseStatusTable(plyId, primary)

    return data and data.values, secondary, GetStatusSettings(primary, secondary) --[[@as table]]
end

-- Whether the player is addicted to a substance, the second return is the addiction level
---@param plyId PlayerId
---@param substance SecondaryName
---@return boolean, number
function IsAddicted(plyId, substance)
    local values, secondary, settings = getEntry(plyId, {primary, substance})
    local entry = values and values[secondary]
    if (not entry) then return false, 0.0 end

    return pastThreshold(entry, settings), entry.addiction
end

exports("IsAddicted", IsAddicted)

-- Hook overrides, registered by statuses/registry.lua
return {
    onTick = function(players)
        for i = 1, #players do
            local plyId, statuses = players[i][1], players[i][2]

            for j = 1, #statuses do
                local secondary, multiplier = statuses[j][1], statuses[j][2]
                local values, _, settings = getEntry(plyId, {primary, secondary})
                local entry = values and values[secondary]
                if (not entry) then goto nextStatus end

                if (pastThreshold(entry, settings)) then
                    local amount = (settings.value.drain or 0.0) * multiplier

                    if (amount > 0.0 and entry.value > 0.0) then
                        entry.value = ClampStatusValue(entry.value - amount)

                        SyncPlayerStatus(plyId, primary)
                    end
                else
                    -- Also runs at 0 drain, so entries left over from an older version get their satisfaction restored
                    RemoveFromStatus(plyId, {primary, secondary}, (settings.addiction.drain or 0.0) * multiplier, true)
                end

                ::nextStatus::
            end
        end
    end,
    onAdd = function(plyId, statusNames, amount)
        local values, secondary, settings = getEntry(plyId, statusNames)
        if (not values) then return end

        local entry = values[secondary]
        entry.addiction = ClampStatusValue(entry.addiction + amount)
        entry.value = ClampStatusValue(entry.value + amount * (settings.value.restore or 1.0))

        return true
    end,
    onRemove = function(plyId, statusNames, amount)
        local values, secondary, settings = getEntry(plyId, statusNames)
        if (not values) then return end

        local entry = values[secondary]
        entry.addiction = ClampStatusValue(entry.addiction - amount)

        -- Dropping below the threshold, by draining or treatment, ends the withdrawal
        if (not pastThreshold(entry, settings)) then
            entry.value = 100.0
        end

        if (entry.addiction <= 0.0) then
            values[secondary] = nil
        end

        return true
    end,
    -- Satisfaction follows the addiction level, setting it alone would leave the two out of sync
    onSet = false,
    onReset = function(plyId, statusNames)
        local values, secondary = getEntry(plyId, statusNames)
        if (not values) then return end

        values[secondary] = nil

        return true
    end,
    -- Heals & revives restore the satisfaction, the addiction itself stays unless the substance clears on heal
    onSoftReset = function(plyId, statusNames)
        local values, secondary, settings = getEntry(plyId, statusNames)
        if (not values) then return end

        if (settings.addiction.clearOnHeal) then
            values[secondary] = nil
        else
            values[secondary].value = 100.0
        end

        return true
    end
}