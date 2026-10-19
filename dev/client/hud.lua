local hudState = GetResourceKvpInt("zyke_status:dev_hud_enabled") or 0

local drawingMethods = {}
drawingMethods.__index = drawingMethods

function drawingMethods:new()
    local self = setmetatable({}, drawingMethods)

    self.queue = {}
    self.offset = 0.025

    return self
end

---@param text string
function drawingMethods:addToQueue(text)
    self.queue[#self.queue+1] = text
end

function drawingMethods:draw()
    for i = 1, #self.queue do
        Z.drawText(self.queue[i], 0.5, 0.01 + self.offset * (i - 1))
    end
end

function drawingMethods:reset()
    self.queue = {}
end

local function devHud()
    CreateThread(function()
        local drawing = drawingMethods:new()

        while (hudState == 1) do
            local sleep = Cache.statuses and 1 or 3000

            if (Cache.statusFrozen == true) then
                drawing:addToQueue("STATUSES FROZEN")
            end

            if (Cache.statuses) then
                local armor = GetPedArmour(PlayerPedId())
                local health = GetEntityHealth(PlayerPedId())

                drawing:addToQueue("armor: " .. armor)
                drawing:addToQueue("health: " .. health)

                for baseStatus, statusData in pairs(Cache.statuses) do
                    for status, subData in pairs(statusData.values) do
                        for valueKey, value in pairs(subData) do
                            local base = baseStatus ~= status and (baseStatus .. "." .. status) or (status)

                            drawing:addToQueue(base .. "." .. valueKey .. ": " .. value)
                        end
                    end
                end
            end

            drawing:draw()
            drawing:reset()

            Wait(sleep)
        end
    end)
end

RegisterCommand("status:dev_hud", function()
    local state = GetResourceKvpInt("zyke_status:dev_hud_enabled") or 0
    local newVal = state == 0 and 1 or 0
    SetResourceKvpInt("zyke_status:dev_hud_enabled", newVal)

    hudState = newVal
    if (not hudState) then return end

    devHud()
end, false)

devHud()