-- Reaction effect: synchronized animations & sounds

local function clearReactionState()
	LocalPlayer.state:set("zyke_status:reaction", nil, true)
end

clearReactionState()

---@class ReactionAnimationLoopSettings
---@field delay integer | {[1]: integer, [2]: integer}
---@field calculatedDelay integer | nil @ Persistent delay so we're not recalculating each tick

---@class ReactionAnimationValue
---@field dict string
---@field clip string
---@field blendInSpeed? number @ Default 1.0
---@field blendOutSpeed? number @ Default 1.0
---@field flag? integer @ Default 49
---@field playbackRate? number @ Default nil
---@field lockX? boolean @ Default false
---@field lockY? boolean @ Default false
---@field lockZ? boolean @ Default false
---@field start? integer @ Default nil
---@field stop? integer @ Default nil
---@field forceAnim? boolean @ Default false
---@field speed? number @ Default 1.0
---@field time? number | "unset" @ Default "unset"

---@class ReactionSoundValue
---@field name string | string[] | { male: string | string[], female: string | string[] }
---@field volume number
---@field distance number

---@class ReactionValue
---@field animation? ReactionAnimationValue
---@field sound? ReactionSoundValue
---@field loop? ReactionAnimationLoopSettings

---@class CurrentReactionData
---@field id string
---@field animation? ReactionAnimationValue
---@field sound? ReactionSoundValue
---@field loop? ReactionAnimationLoopSettings
---@field lastStartedPlaying integer
---@field playCounter integer
---@field soundActive boolean

---@type table<string, CurrentReactionData>
local queuedReactions = {}

-- Track if zyke_sounds is available (checked once at init)
local hasSounds = GetResourceState("zyke_sounds") == "started" or GetResourceState("zyke_sounds") == "starting"

-- Animation duration calculation
---@param animData ReactionAnimationValue
---@return integer @ Milliseconds
local function getAnimDuration(animData)
	if (animData.stop ~= nil and animData.start ~= nil) then
		---@diagnostic disable-next-line: return-type-mismatch
		return math.tointeger(animData.stop - animData.start)
	elseif (animData.stop ~= nil) then
		return animData.stop
	elseif (animData.start ~= nil) then
		local animLen = GetAnimDuration(animData.dict, animData.clip) * 1000
		---@diagnostic disable-next-line: return-type-mismatch
		return math.tointeger(animLen - animData.start)
	else
		---@diagnostic disable-next-line: return-type-mismatch
		return math.tointeger(GetAnimDuration(animData.dict, animData.clip) * 1000)
	end
end

---@param data ReactionAnimationValue
---@param queueId string
local function taskPlayAnim(data, queueId)
	if (not Z.loadDict(data.dict)) then Z.debug("^1[zyke_status] Missing or invalid animation dictionary for reaction^7") return end

	data.speed = data.speed == nil and 1.0 or data.speed
	data.time = data.time == nil and "unset" or data.time
	data.playbackRate = data.playbackRate == nil and 1.0 or data.playbackRate

	local duration = getAnimDuration(data)

	local state = LocalPlayer.state["zyke_status:reaction"]
	if (data.forceAnim or state == nil or (state.dict ~= data.dict or state.clip ~= data.clip)) then
		_TaskPlayAnim(PlayerPedId(), data.dict, data.clip, data.blendInSpeed, data.blendOutSpeed, duration, data.flag, data.playbackRate, data.lockX, data.lockY, data.lockZ)
		queuedReactions[queueId].playCounter = queuedReactions[queueId].playCounter + 1
	end

	LocalPlayer.state:set("zyke_status:reaction", {
		dict = data.dict,
		clip = data.clip,
		speed = data.speed,
		time = data.time,
		set = GetNetworkTimeAccurate()
	}, true)
end

_TaskPlayAnim = TaskPlayAnim

-- Plays the animation part of a reaction
---@param val ReactionValue
---@param queueId string
local function playReactionAnimation(val, queueId)
	if (not val.animation) then return end

	local animData = val.animation

	taskPlayAnim(
		{
			dict = animData.dict,
			clip = animData.clip,
			blendInSpeed = animData.blendInSpeed or 1.0,
			blendOutSpeed = animData.blendOutSpeed or 1.0,
			flag = animData.flag or 51,
			playbackRate = 0,
			lockX = false,
			lockY = false,
			lockZ = false,
			start = animData.start or nil,
			stop = animData.stop or nil,
			forceAnim = animData.forceAnim or false,
			speed = animData.speed or 1.0,
			time = animData.start or nil
		},
		queueId
	)
end

-- Starts reaction sound via callback (blocks until server confirms)
---@param queueId string
---@return boolean
local function startReactionSound(queueId)
	if (not hasSounds) then return false end

	local success = Z.callback.await("zyke_status:ReactionSound", queueId, "start")
	return success == true
end

-- Stops reaction sound (fire-and-forget)
---@param queueId string
local function stopReactionSound(queueId)
	if (not hasSounds) then return end

	TriggerServerEvent("zyke_status:StopReactionSound", queueId)
end

---@param val ReactionValue
---@param queueId string
local function ensureReaction(val, queueId)
	local reactionData = queuedReactions[queueId]
	local hasAnimation = val.animation ~= nil
	local hasSound = val.sound ~= nil

	if (reactionData) then
		-- Already tracked, check if animation is still playing
		if (hasAnimation) then
			local isPlayingAnim = IsEntityPlayingAnim(PlayerPedId(), val.animation.dict, val.animation.clip, 3)
			if (isPlayingAnim) then return end
		end

		if (reactionData.playCounter > 0) then
			local loop = val.loop or reactionData.loop
			if (loop == nil) then return end
		end

		-- Check loop delay
		if (reactionData.loop and reactionData.loop.calculatedDelay ~= nil and hasAnimation) then
			local shouldStopPlaying = reactionData.lastStartedPlaying + getAnimDuration(val.animation)
			local diff = GetGameTimer() - shouldStopPlaying

			if (diff < reactionData.loop.calculatedDelay) then return end
		end

		-- Update tracking
		queuedReactions[queueId] = Z.table.copy(val)
		queuedReactions[queueId].playCounter = reactionData.playCounter + 1
		queuedReactions[queueId].lastStartedPlaying = reactionData.lastStartedPlaying
		queuedReactions[queueId].soundActive = reactionData.soundActive

		clearReactionState()
	else
		-- First time, initialize tracking
		local newReaction = Z.table.copy(val)

		newReaction.id = queueId
		newReaction.playCounter = 0
		newReaction.soundActive = false

		queuedReactions[queueId] = newReaction
	end

	reactionData = queuedReactions[queueId]

	-- Check if animation is already playing
	if (hasAnimation) then
		local ply = PlayerPedId()
		if (IsEntityPlayingAnim(ply, val.animation.dict, val.animation.clip, 3)) then return end
		if (not Z.loadDict(val.animation.dict)) then Z.debug("^1[zyke_status] Invalid animation dict for reaction^7") return end
	end

	-- Start sound first via callback (blocks until server confirms), then play animation
	-- This ensures both start at roughly the same time for the local player
	if (hasSound) then
		startReactionSound(queueId)
		reactionData.soundActive = true
	end

	-- Play animation after sound has been dispatched
	if (hasAnimation) then
		playReactionAnimation(val, queueId)
	end

	-- Calculate loop delay
	local loop = val.loop or reactionData.loop
	if (loop ~= nil) then
		local delay = loop.delay
		if (type(delay) == "table") then
			delay = math.random(delay[1], delay[2])
		end

		reactionData.loop = reactionData.loop or {}
		reactionData.loop.calculatedDelay = math.tointeger(delay)
	end

	queuedReactions[queueId].lastStartedPlaying = GetGameTimer()
end

---@param queueId string
local function clearReaction(queueId)
	if (queuedReactions == nil) then return end

	local reactionData = queuedReactions[queueId]
	if (not reactionData) then return end

	-- Stop animation
	if (reactionData.animation) then
		if (IsEntityPlayingAnim(PlayerPedId(), reactionData.animation.dict, reactionData.animation.clip, 3)) then
			local ply = PlayerPedId()
			StopAnimTask(ply, reactionData.animation.dict, reactionData.animation.clip, 1.0)
		end
	end

	-- Stop sound
	if (reactionData.soundActive) then
		stopReactionSound(queueId)
	end

	queuedReactions[queueId] = nil
	clearReactionState()
end

local function clearAllReactions()
	for queueId, reactionData in pairs(queuedReactions) do
		-- Stop animation
		if (reactionData.animation) then
			if (IsEntityPlayingAnim(PlayerPedId(), reactionData.animation.dict, reactionData.animation.clip, 3)) then
				local ply = PlayerPedId()
				StopAnimTask(ply, reactionData.animation.dict, reactionData.animation.clip, 1.0)
			end
		end

		-- Stop sound
		if (reactionData.soundActive) then
			stopReactionSound(queueId)
		end

		queuedReactions[queueId] = nil
	end

	clearReactionState()
end

RegisterQueueKey("reaction", {
	---@param val ReactionValue | table
	---@return ReactionValue
	normalize = function(val)
		local hasAnimation = val.animation ~= nil
		local hasSound = val.sound ~= nil

		if (not hasAnimation and not hasSound) then
			Z.debug("^1[zyke_status] Reaction effect must have at least one of 'animation' or 'sound' defined^7")
		end

		local normalized = {}

		if (hasAnimation) then
			local anim = val.animation
			normalized.animation = {
				dict = anim.dict,
				clip = anim.clip,
				blendInSpeed = anim.blendInSpeed or 1.0,
				blendOutSpeed = anim.blendOutSpeed or 1.0,
				flag = anim.flag or 49,
				playbackRate = anim.playbackRate,
				lockX = anim.lockX or false,
				lockY = anim.lockY or false,
				lockZ = anim.lockZ or false,
				start = anim.start or nil,
				stop = anim.stop or nil,
				forceAnim = anim.forceAnim or false,
				speed = anim.speed or 1.0,
				time = anim.time or "unset",
			}
		end

		if (hasSound) then
			normalized.sound = {
				name = val.sound.name,
				volume = val.sound.volume or 0.3,
				distance = val.sound.distance or 10.0,
			}
		end

		if (val.loop) then
			normalized.loop = val.loop
		end

		return normalized
	end,
	---@param val1 ReactionValue
	---@param val2 ReactionValue
	---@param thresholdIdx1 integer
	---@param thresholdIdx2 integer
	---@return integer
	compare = function(val1, val2, thresholdIdx1, thresholdIdx2)
		return 0 -- Always use threshold fallback
	end,
	---@param val ReactionValue
	---@param queueId string
	onTick = function(val, queueId)
		ensureReaction(val, queueId)
	end,
	---@param val ReactionValue
	---@param queueId string
	onStop = function(val, queueId)
		clearReaction(queueId)
	end,
	onResourceStop = function()
		clearAllReactions()
	end,
	reset = function()
		clearAllReactions()
	end
})

-- State bag replication for other players to see animations
---@class StateBagReactionInfo
---@field dict string
---@field clip string
---@field speed number
---@field time number | "unset"
---@field set number

---@param bagName string
---@param key string
---@param value StateBagReactionInfo
---@diagnostic disable-next-line: param-type-mismatch
AddStateBagChangeHandler("zyke_status:reaction", nil, function(bagName, key, value)
	if (value == nil) then return end

	local plyIdx = GetPlayerFromStateBagName(bagName)
	local ply = GetPlayerPed(plyIdx)
	local dict, clip = value.dict, value.clip

	local hasStarted = Z.awaitingAnim(ply, dict, clip, 1000)
	if (not hasStarted) then return end

	if (value.time ~= "unset") then
		local animLen = GetAnimDuration(dict, clip) * 1000
		local normalizedTime = value.time / animLen

		---@diagnostic disable-next-line: param-type-mismatch
		SetEntityAnimCurrentTime(ply, dict, clip, normalizedTime)
	end

	SetEntityAnimSpeed(ply, dict, clip, value.speed + 0.0)
end)
