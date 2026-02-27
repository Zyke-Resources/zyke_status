Z.callback.register("zyke_status:GetPlayerStatus", function(plyId) return GetAllRawStatuses(plyId) end)

if (Config.Settings.stressEvents.gainStress == true) then
    RegisterNetEvent("hud:server:GainStress", function(amount)
        if (amount < 0) then return end

        if (Config.Settings.debug) then
            Z.debug(("[GainStress] %s gaining %s stress"):format(source, amount))
        end

        local prev = GetStatus(source, {"stress"})
        local newVal = prev + amount
        if (newVal > 100) then newVal = 100 end

        SetStatusValue(source, {"stress"}, newVal)
    end)
end

if (Config.Settings.stressEvents.relieveStress == true) then
    RegisterNetEvent("hud:server:RelieveStress", function(amount)
        if (amount <= 0) then return end

        if (Config.Settings.debug) then
            Z.debug(("[RelieveStress] %s relieving %s stress"):format(source, amount))
        end

        local prev = GetStatus(source, {"stress"})
        local newVal = prev - amount
        if (newVal < 0) then newVal = 0 end

        SetStatusValue(source, {"stress"}, newVal)
    end)
end

if (EXTERNAL_RESOURCES["wasabi_ambulance"] == false) then
    -- txAdmin event for healing a player
    ---@param eventData {id: integer}
    AddEventHandler("txAdmin:events:healedPlayer", function(eventData)
        if (GetInvokingResource() ~= "monitor") then return end -- Validate that the request is actually from tx
        if (type(eventData) ~= "table" or type(eventData.id) ~= "number") then return end

        Z.debug("[txAdmin] Healing player", eventData.id)
        HealPlayer(eventData.id)
    end)
end