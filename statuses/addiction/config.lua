-- Settings specifically for addiction
-- `addiction` is how addicted you are, below the threshold it drains by itself, at or above it you are addicted and it stays until treated
-- `value` is your satisfaction, it stays at 100.0 while you are not addicted and drains while you are, each use restores it
-- Treat an addiction by removing from it, ex. exports.zyke_status:RemoveFromStatus(plyId, {"addiction", "nicotine"}, 100.0)
Config.Status.addiction = {
    ["base"] = { -- Base value if nothing else is defined
        addiction = {
            drain = 0.01, -- Per second while below the threshold, 0.01 clears 36.0 per hour
            threshold = 20.0,
            clearOnHeal = false, -- Clears the addiction on heals & revives, otherwise only the satisfaction is restored
        },
        value = {
            drain = 0.01, -- Per second while addicted, 0.01 empties it in ~2.8 hours
            restore = 10.0, -- Satisfaction restored per point of addiction added, a use adding 3.0 addiction restores 30.0
        },
        -- Satisfaction thresholds, lower is worse
        effect = {
            {
                threshold = 60.0,
                notification = {value = "withdrawal1", play = "start"},
            },
            {
                threshold = 35.0,
                notification = {value = "withdrawal2", play = "start"},
                cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.1},
                walkingStyle = "move_m@sad@a",
            },
            {
                threshold = 15.0,
                notification = {value = "withdrawal3", play = "start"},
                screenEffect = {value = "WeaponUpgrade", intensity = 0.5},
                cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.25},
                blockSprinting = true,
            },
        },
    },
    ["thc"] = { -- Harder to get addicted, milder withdrawal
        addiction = {
            drain = 0.01,
            threshold = 30.0,
            clearOnHeal = false,
        },
        value = {
            drain = 0.008,
            restore = 10.0,
        },
        effect = {
            {
                threshold = 50.0,
                notification = {value = "withdrawal1", play = "start"},
            },
            {
                threshold = 20.0,
                notification = {value = "withdrawal2", play = "start"},
                walkingStyle = "move_m@sad@a",
            },
            {
                threshold = 5.0,
                notification = {value = "withdrawal3", play = "start"},
                screenEffect = {value = "WeaponUpgrade", intensity = 0.3},
            },
        },
    },
    ["nicotine"] = { -- Easy to get addicted, quick cravings with mild withdrawal
        addiction = {
            drain = 0.002,
            threshold = 15.0,
            clearOnHeal = false,
        },
        value = {
            drain = 0.02,
            restore = 10.0,
        },
        effect = {
            {
                threshold = 60.0,
                notification = {value = "withdrawal1", play = "start"},
            },
            {
                threshold = 30.0,
                notification = {value = "withdrawal2", play = "start"},
                cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.08},
            },
            {
                threshold = 10.0,
                notification = {value = "withdrawal3", play = "start"},
                screenEffect = {value = "WeaponUpgrade", intensity = 0.4},
                cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.15},
            },
        },
    },
    ["cocaine"] = { -- Strong cravings, the crash leaves you sluggish
        addiction = {
            drain = 0.004,
            threshold = 15.0,
            clearOnHeal = false,
        },
        value = {
            drain = 0.025,
            restore = 10.0,
        },
        effect = {
            {
                threshold = 60.0,
                notification = {value = "withdrawal1", play = "start"},
            },
            {
                threshold = 35.0,
                notification = {value = "withdrawal2", play = "start"},
                walkingStyle = "move_m@sad@a",
                movementSpeed = 0.95,
            },
            {
                threshold = 15.0,
                notification = {value = "withdrawal3", play = "start"},
                screenEffect = {value = "WeaponUpgrade", intensity = 0.6},
                cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.2},
                movementSpeed = 0.9,
                blockSprinting = true,
            },
        },
    },
}