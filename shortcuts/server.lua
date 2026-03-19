-- Shortcuts to common functions, for easier development

---@param plyId PlayerId
---@return number
exports("GetStress", function(plyId)
    return GetRawStatus(plyId, {"stress", "stress"}).value
end)

---@param plyId PlayerId
---@return number
exports("GetHunger", function(plyId)
    return GetRawStatus(plyId, {"hunger", "hunger"}).value
end)

---@param plyId PlayerId
---@return number
exports("GetThirst", function(plyId)
    return GetRawStatus(plyId, {"thirst", "thirst"}).value
end)

---@param plyId PlayerId
---@return number
exports("GetDrunk", function(plyId)
    return GetRawStatus(plyId, {"drunk", "drunk"}).value
end)