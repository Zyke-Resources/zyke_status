-- Every status type, each with a folder in statuses/ holding its config.lua
-- A server.lua in the folder is optional and returns hook overrides for RegisterStatusType
---@type table<PrimaryName, StatusType>
StatusTypes = {
    addiction = {multi = true, reversed = true, values = {addiction = 0.0}},
    caffeine = {},
    drunk = {},
    high = {multi = true},
    hunger = {reversed = true},
    stress = {},
    thirst = {reversed = true},
}

-- Runs a file from a status folder, the second return is whatever the file returns
---@param path string
---@return boolean exists, any result
local function runStatusFile(path)
    local chunk = LoadResourceFile(ResName, path)
    if (not chunk) then return false end

    local func, err = load(chunk, ("@@%s/%s"):format(ResName, path))
    if (not func) then error(err) end

    return true, func()
end

for name in pairs(StatusTypes) do
    local hasConfig = runStatusFile(("statuses/%s/config.lua"):format(name))
    if (not hasConfig) then error(("Status %s is missing statuses/%s/config.lua"):format(name, name)) end

    if (Context == "server") then
        local _, functions = runStatusFile(("statuses/%s/server.lua"):format(name))

        RegisterStatusType(name, functions)
    end
end

EnsureEffectThresholdOrder()