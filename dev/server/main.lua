---@param plyId PlayerId
local function isAllowed(plyId)
    if (plyId == 0) then return true end

    return Z.hasPermission(plyId, "command")
end

Z.registerCommand({"status", "stat"}, function(plyId, args)
    local isInvokerServer = plyId == 0

    if (not isAllowed(plyId)) then
        if (isInvokerServer) then
            print("Failed to execute command, reason:", T("noPermission"))
        else
            Z.notify(plyId, "noPermission")
        end

        return
    end

    local primary, secondary, action, amount = args[1], args[2], args[3], tonumber(args[4])
    if (not amount or type(amount) ~= "number" or amount <= 0.0) then
        if (isInvokerServer) then
            print("Failed to execute command, reason:", T("invalidAmount"))
        else
            Z.notify(plyId, "invalidAmount")
        end

        return
    end

    if (action == "add" or action == "+") then
        AddToStatus(plyId, {primary, secondary}, amount)
    elseif (action == "remove" or action == "-") then
        RemoveFromStatus(plyId, {primary, secondary}, amount)
    else
        if (isInvokerServer) then
            print("Failed to execute command, reason:", T("incorrectAction"))
        else
            Z.notify(plyId, "incorrectAction")
        end
    end
end, "Add/Remove from player status", {
    {"primary", "Primary status name (ex. high)"},
    {"secondary", "Secondary status name (ex. coke)"},
    {"action", "add/remove"},
    {"amount", "0-100"},
})

Z.registerCommand({"status_clear", "sclear", "status_reset", "sreset"}, function(plyId, args)
    local isInvokerServer = plyId == 0

    if (not isAllowed(plyId)) then
        if (isInvokerServer) then
            print("Failed to execute command, reason:", T("noPermission"))
        else
            Z.notify(plyId, "noPermission")
        end

        return
    end

    ResetStatuses(plyId)

    if (isInvokerServer) then
        print("Player statuses have been reset.")
    else
        Z.notify(plyId, "statusesReset")
    end
end, "Reset Player Status", {
    {"Player Id", "Player Id, or empty to use yourself"}
})

-- Forcefully save the status of yourself
-- Mainly used for my own development when restarting & I want to save some initial state to resume from for each script restart
Z.registerCommand({"status_save"}, function(plyId, args)
    local isInvokerServer = plyId == 0

    if (not isAllowed(plyId)) then
        if (isInvokerServer) then
            print("Failed to execute command, reason:", T("noPermission"))
        else
            Z.notify(plyId, "noPermission")
        end

        return
    end

    SavePlayerToDatabase(plyId)

    if (isInvokerServer) then
        print("Status has been saved.")
    else
        Z.notify(plyId, "statusSaved")
    end
end)

-- QB eating testing
-- RegisterCommand("hunger_test", function(source, args)
--     -- local ply = Z.getPlayerData(source)
--     -- ply.Functions.SetMetaData("hunger", ply.PlayerData.metadata.hunger + tonumber(args[1]))

--     TriggerClientEvent("consumables:client:Eat", source, nil, tonumber(args[1]))
-- end, false)
