Config.Status.hunger = {
    ["base"] = {
        value = {
            -- Per second 0.005 takes 200 seconds to drain 1%, which is ~320 minutes for 100%
            drain = 0.005,
        },
        effect = {
            {
                threshold = 40.0,
                notification = {value = "hunger1", play = "start"},
                reaction = {
                    sound = {
                        name = "stomach_growl.ogg",
                        volume = 0.2,
                        distance = 2.0,
                    },
                },
            },
            {
                -- Start being hungry, slight screen effect
                threshold = 30.0,
                notification = {value = "hunger2", play = "start"},
                reaction = {
                    sound = {
                        name = "stomach_growl.ogg",
                        volume = 0.2,
                        distance = 2.0,
                    },
                },
            },
            {
                -- Start being very hungry, noticeable screen effect
                -- Very slight camera shaking
                threshold = 10.0,
                notification = {value = "hunger3", play = "start"},
                screenEffect = {value = "WeaponUpgrade", intensity = 0.6},
                cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.2},
                walkingStyle = "move_m@sad@a",
                reaction = {
                    sound = {
                        name = "stomach_growl.ogg",
                        volume = 0.2,
                        distance = 2.0,
                    },
                },
            },
            {
                -- Complete starvation
                -- Very noticeable screen effect, impaired vision
                -- Taking slow damage
                -- Noticeable camera shaking, feeling dizzy
                -- Restricted movement due to low energy levels
                threshold = 0.0,
                notification = {value = "hunger4", play = "start"},
                screenEffect = {value = "WeaponUpgrade", intensity = 0.8},
                cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.8},
                blockSprinting = true,
                blockJumping = true,
                damage = 0.25,
                reaction = {
                    sound = {
                        name = "stomach_growl.ogg",
                        volume = 0.2,
                        distance = 2.0,
                    },
                },
            },
        }
    }
}