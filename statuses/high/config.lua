Config.Status.high = {
    -- Base (fallback for unknown drug highs): light altered perception with moderate impairment at high values
    ["base"] = {
        value = {
            drain = 0.03,
        },
        effect = {
            {threshold = 15.0, screenEffect = {value = "Dax_TripBlend01", intensity = 0.5}},
            {threshold = 35.0, screenEffect = {value = "Dax_TripBlend01", intensity = 0.6}, walkingStyle = "move_m@buzzed"},
            {threshold = 65.0, screenEffect = {value = "Dax_TripBlend01", intensity = 0.8}, blurryVision = true},
            {threshold = 85.0, screenEffect = {value = "Dax_TripBlend01", intensity = 1.0}, walkingStyle = "move_m@drunk@slightlydrunk"},
        },
    },

    -- THC: cannabis high with altered senses, relaxation, coordination loss, and paranoia at high values
    ["thc"] = {
        value = {
            drain = 0.05,
        },
        effect = {
            {threshold = 10.0, screenEffect = {value = "glasses_yellow", intensity = 0.6}},
            {threshold = 25.0, screenEffect = {value = "glasses_yellow", intensity = 0.8}, walkingStyle = "move_m@buzzed"},
            {threshold = 45.0, screenEffect = {value = "glasses_yellow", intensity = 0.8}, blurryVision = true},
            {threshold = 65.0, screenEffect = {value = "glasses_yellow", intensity = 1.0}, walkingStyle = "move_m@drunk@slightlydrunk"},
            {threshold = 80.0, screenEffect = {value = "glasses_yellow", intensity = 1.1}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.2}, walkingStyle = "move_m@drunk@a"},
            {threshold = 95.0, screenEffect = {value = "glasses_yellow", intensity = 1.2}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.35}, blurryVision = true},
        },
    },

    -- Synthetic cannabinoids: spice/K2 style high with harsher panic, psychosis, and health danger
    ["synthetic_cannabinoid"] = {
        value = {
            drain = 0.06,
        },
        effect = {
            {threshold = 10.0, screenEffect = {value = "MP_Arena_theme_storm", intensity = 0.8}},
            {threshold = 25.0, screenEffect = {value = "MP_Arena_theme_storm", intensity = 1.0}, walkingStyle = "move_m@buzzed"},
            {threshold = 45.0, screenEffect = {value = "MP_Arena_theme_storm", intensity = 1.0}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.25}, blurryVision = true},
            {threshold = 65.0, screenEffect = {value = "MP_Arena_theme_storm", intensity = 1.0}, walkingStyle = "move_m@drunk@a", blockJumping = true},
            {threshold = 85.0, screenEffect = {value = "MP_Arena_theme_storm", intensity = 1.0}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.45}, blockSprinting = true, damage = 0.75},
            {threshold = 100.0, damage = 2.0},
        },
    },

    -- Nicotine: short stimulant buzz that becomes dizzy and nauseating when stacked
    ["nicotine"] = {
        value = {
            drain = 0.07,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "NG_filmic15", intensity = 0.45}, movementSpeed = 1.02},
            {threshold = 15.0, screenEffect = {value = "NG_filmic15", intensity = 0.6}, movementSpeed = 1.04},
            {threshold = 30.0, screenEffect = {value = "NG_filmic15", intensity = 0.7}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.05}},
            {threshold = 50.0, screenEffect = {value = "NG_filmic15", intensity = 0.7}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.1}},
            {threshold = 70.0, screenEffect = {value = "NG_filmic15", intensity = 0.8}, blurryVision = true},
        },
    },

    -- Cocaine: stimulant high with energy, sensory intensity, anxiety, paranoia, and cardiac danger
    ["cocaine"] = {
        value = {
            drain = 0.08,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "DanceIntensity02", intensity = 0.6}, movementSpeed = 1.08},
            {threshold = 20.0, screenEffect = {value = "DanceIntensity02", intensity = 0.9}, movementSpeed = 1.15},
            {threshold = 40.0, screenEffect = {value = "DanceIntensity02", intensity = 1.0}, movementSpeed = 1.2, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.05}},
            {threshold = 65.0, screenEffect = {value = "DanceIntensity02", intensity = 1.1}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.2}},
            {threshold = 85.0, screenEffect = {value = "DanceIntensity02", intensity = 1.3}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.35}, damage = 0.5},
            {threshold = 100.0, damage = 2.0},
        },
    },

    -- Crack: shorter and harsher cocaine high with quicker danger escalation
    ["crack"] = {
        value = {
            drain = 0.12,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "DaxTrip03", intensity = 0.8}, movementSpeed = 1.12},
            {threshold = 20.0, screenEffect = {value = "DaxTrip03", intensity = 1.0}, movementSpeed = 1.18, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.08}},
            {threshold = 40.0, screenEffect = {value = "DaxTrip03", intensity = 1.1}, movementSpeed = 1.2, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.22}},
            {threshold = 65.0, screenEffect = {value = "DaxTrip03", intensity = 1.35}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.4}, blurryVision = true, damage = 0.75},
            {threshold = 90.0, damage = 1.5},
            {threshold = 100.0, damage = 3.0},
        },
    },

    -- Meth: long stimulant high with restlessness, paranoia, hallucinations, and body strain
    ["meth"] = {
        value = {
            drain = 0.04,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "DaxTrip03", intensity = 0.6}, movementSpeed = 1.08},
            {threshold = 20.0, screenEffect = {value = "DaxTrip03", intensity = 0.9}, movementSpeed = 1.15},
            {threshold = 45.0, screenEffect = {value = "DaxTrip03", intensity = 1.1}, movementSpeed = 1.2, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.15}},
            {threshold = 65.0, screenEffect = {value = "DaxTrip03", intensity = 1.3}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.3}},
            {threshold = 85.0, screenEffect = {value = "DaxTrip03", intensity = 1.4}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.45}, blurryVision = true, damage = 0.75},
            {threshold = 100.0, damage = 2.0},
        },
    },

    -- Amphetamine: speed/amphetamine high with energy, focus, jitter, and high-dose strain
    ["amphetamine"] = {
        value = {
            drain = 0.06,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "DanceIntensity02", intensity = 0.5}, movementSpeed = 1.05},
            {threshold = 20.0, screenEffect = {value = "DanceIntensity02", intensity = 0.7}, movementSpeed = 1.1},
            {threshold = 45.0, screenEffect = {value = "DanceIntensity02", intensity = 0.9}, movementSpeed = 1.15, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.08}},
            {threshold = 70.0, screenEffect = {value = "DanceIntensity02", intensity = 1.0}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.25}},
            {threshold = 95.0, screenEffect = {value = "DanceIntensity02", intensity = 1.0}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.35}, damage = 0.75},
        },
    },

    -- MDMA: empathogenic stimulant high with euphoria, sensory intensity, and overheating danger
    ["mdma"] = {
        value = {
            drain = 0.04,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "DanceIntensity02", intensity = 0.6}, movementSpeed = 1.03},
            {threshold = 20.0, screenEffect = {value = "DanceIntensity02", intensity = 0.9}, movementSpeed = 1.08},
            {threshold = 45.0, screenEffect = {value = "DanceIntensity02", intensity = 1.0}, movementSpeed = 1.12, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.05}},
            {threshold = 70.0, screenEffect = {value = "DanceIntensity02", intensity = 1.1}, movementSpeed = 1.15, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.2}},
            {threshold = 90.0, screenEffect = {value = "DanceIntensity02", intensity = 1.35}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.35}, damage = 0.75},
            {threshold = 100.0, damage = 1.5},
        },
    },

    -- LSD: psychedelic high focused on hallucination, time distortion, and loss of control
    ["lsd"] = {
        value = {
            drain = 0.02,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "DaxTrip03", intensity = 0.8}},
            {threshold = 20.0, screenEffect = {value = "DaxTrip03", intensity = 1.0}},
            {threshold = 45.0, screenEffect = {value = "DaxTrip03", intensity = 1.2}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.08}},
            {threshold = 70.0, screenEffect = {value = "DaxTrip03", intensity = 1.35}, walkingStyle = "move_m@buzzed", blurryVision = true},
            {threshold = 90.0, screenEffect = {value = "DaxTrip03", intensity = 1.45}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.25}, blockJumping = true, stumble = 0.12},
        },
    },

    -- Psilocybin: mushroom high with softer visual distortion and anxiety at high values
    ["psilocybin"] = {
        value = {
            drain = 0.025,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "Dax_TripBlend01", intensity = 0.7}},
            {threshold = 20.0, screenEffect = {value = "Dax_TripBlend01", intensity = 0.9}},
            {threshold = 45.0, screenEffect = {value = "Dax_TripBlend01", intensity = 1.1}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.05}},
            {threshold = 70.0, screenEffect = {value = "Dax_TripBlend01", intensity = 1.1}, walkingStyle = "move_m@buzzed", blurryVision = true},
            {threshold = 90.0, screenEffect = {value = "Dax_TripBlend01", intensity = 1.35}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.2}},
        },
    },

    -- DMT: very short, intense psychedelic high with extreme visual distortion
    ["dmt"] = {
        value = {
            drain = 0.25,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "DaxTrip03", intensity = 1.0}},
            {threshold = 20.0, screenEffect = {value = "DaxTrip03", intensity = 1.2}},
            {threshold = 45.0, screenEffect = {value = "DaxTrip03", intensity = 1.35}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.1}, blurryVision = true},
            {threshold = 70.0, screenEffect = {value = "DaxTrip03", intensity = 1.5}, walkingStyle = "move_m@buzzed", blockJumping = true, blockSprinting = true, stumble = 0.12},
            {threshold = 90.0, screenEffect = {value = "DaxTrip03", intensity = 1.5}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.3}, stumble = 0.2},
        },
    },

    -- Salvia: short dissociative psychedelic high with abrupt disorientation
    ["salvia"] = {
        value = {
            drain = 0.2,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "ArenaEMP_Blend", intensity = 0.8}},
            {threshold = 20.0, screenEffect = {value = "ArenaEMP_Blend", intensity = 1.1}},
            {threshold = 45.0, screenEffect = {value = "ArenaEMP_Blend", intensity = 1.3}, walkingStyle = "move_m@buzzed"},
            {threshold = 70.0, screenEffect = {value = "ArenaEMP_Blend", intensity = 1.45}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.2}, blockJumping = true, blockSprinting = true, stumble = 0.14},
        },
    },

    -- Ketamine: dissociative high with detachment, heavy motor impairment, and k-hole danger
    ["ketamine"] = {
        value = {
            drain = 0.05,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "phone_cam11", intensity = 0.6}},
            {threshold = 20.0, screenEffect = {value = "phone_cam11", intensity = 0.9}, walkingStyle = "move_m@buzzed"},
            {threshold = 45.0, screenEffect = {value = "phone_cam11", intensity = 1.2}, walkingStyle = "move_m@drunk@slightlydrunk", blurryVision = true},
            {threshold = 70.0, screenEffect = {value = "phone_cam11", intensity = 1.2}, blockSprinting = true, blockJumping = true, stumble = 0.14},
            {threshold = 90.0, screenEffect = {value = "phone_cam11", intensity = 1.35}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.25}, damage = 0.5},
        },
    },

    -- PCP: dissociative high with strength/agitation, paranoia, and dangerous behavior at high values
    ["pcp"] = {
        value = {
            drain = 0.04,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "BikerFilter", intensity = 0.6}, strength = 1.1},
            {threshold = 20.0, screenEffect = {value = "BikerFilter", intensity = 0.8}, walkingStyle = "move_m@buzzed", strength = 1.15},
            {threshold = 45.0, screenEffect = {value = "BikerFilter", intensity = 1.0}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.2}, strength = 1.2},
            {threshold = 70.0, screenEffect = {value = "BikerFilter", intensity = 1.3}, walkingStyle = "move_m@drunk@a", blurryVision = true, strength = 1.25},
            {threshold = 90.0, screenEffect = {value = "BikerFilter", intensity = 1.4}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.45}, damage = 1.0},
        },
    },

    -- N2O: whippet/nitrous high with fast dizziness and dangerous oxygen-loss escalation
    ["n2o"] = {
        value = {
            drain = 1.0,
        },
        effect = {
            {threshold = 10.0, screenEffect = {value = "BeastLaunch02", intensity = 0.8}, walkingStyle = "move_m@buzzed"},
            {threshold = 20.0, screenEffect = {value = "BeastLaunch02", intensity = 0.9}, walkingStyle = "move_m@drunk@slightlydrunk"},
            {threshold = 35.0, screenEffect = {value = "BeastLaunch02", intensity = 1.0}, blurryVision = true},
            {threshold = 50.0, screenEffect = {value = "BeastLaunch02", intensity = 1.2}, walkingStyle = "move_m@drunk@a", blockSprinting = true, stumble = 0.12, damage = 0.4},
            {threshold = 70.0, screenEffect = {value = "BeastLaunch02", intensity = 1.35}, walkingStyle = "move_m@drunk@verydrunk", blockJumping = true, stumble = 0.25, damage = 1.0},
            {threshold = 100.0, damage = 3.0},
        },
    },

    -- Opioids: heroin/oxy style high with euphoria, sedation, and respiratory danger at high values
    ["opioid"] = {
        value = {
            drain = 0.03,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "InchPurple02", intensity = 0.6}, walkingStyle = "move_m@buzzed"},
            {threshold = 20.0, screenEffect = {value = "InchPurple02", intensity = 0.8}, blurryVision = true},
            {threshold = 40.0, screenEffect = {value = "InchPurple02", intensity = 1.0}, walkingStyle = "move_m@drunk@slightlydrunk", blockSprinting = true},
            {threshold = 65.0, screenEffect = {value = "InchPurple02", intensity = 1.3}, walkingStyle = "move_m@drunk@a", blockJumping = true, stumble = 0.12, damage = 0.5},
            {threshold = 85.0, screenEffect = {value = "InchPurple02", intensity = 1.4}, walkingStyle = "move_m@drunk@verydrunk", damage = 1.5},
            {threshold = 100.0, damage = 3.0},
        },
    },

    -- Fentanyl: severe opioid high; dangerous effects begin early and escalate quickly
    ["fentanyl"] = {
        value = {
            drain = 0.05,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "BarryFadeOut", intensity = 1.0}, walkingStyle = "move_m@buzzed", cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.1}},
            {threshold = 10.0, screenEffect = {value = "BarryFadeOut", intensity = 1.3}, walkingStyle = "move_m@drunk@slightlydrunk", blockSprinting = true, stumble = 0.12, damage = 1.0},
            {threshold = 20.0, screenEffect = {value = "BarryFadeOut", intensity = 1.35}, walkingStyle = "move_m@drunk@verydrunk", blockJumping = true, blurryVision = true, damage = 2.0},
            {threshold = 35.0, damage = 3.0},
            {threshold = 50.0, damage = 4.0},
        },
    },

    -- Benzodiazepine: calming/sedative high with blackout-style motor impairment at high values
    ["benzodiazepine"] = {
        value = {
            drain = 0.03,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "phone_cam11", intensity = 0.5}},
            {threshold = 20.0, screenEffect = {value = "phone_cam11", intensity = 0.7}, walkingStyle = "move_m@buzzed"},
            {threshold = 45.0, screenEffect = {value = "phone_cam11", intensity = 1.0}, walkingStyle = "move_m@drunk@slightlydrunk", blockSprinting = true},
            {threshold = 70.0, screenEffect = {value = "phone_cam11", intensity = 1.2}, walkingStyle = "move_m@drunk@a", blockJumping = true, blurryVision = true, stumble = 0.12},
            {threshold = 95.0, screenEffect = {value = "phone_cam11", intensity = 1.35}, damage = 0.75},
        },
    },

    -- GHB: euphoric sedative high that turns into blackout and respiratory danger
    ["ghb"] = {
        value = {
            drain = 0.05,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "InchPurple02", intensity = 0.6}},
            {threshold = 20.0, screenEffect = {value = "InchPurple02", intensity = 0.8}, movementSpeed = 1.03},
            {threshold = 45.0, screenEffect = {value = "InchPurple02", intensity = 1.0}, walkingStyle = "move_m@buzzed"},
            {threshold = 70.0, screenEffect = {value = "InchPurple02", intensity = 1.3}, walkingStyle = "move_m@drunk@a", blockSprinting = true, blurryVision = true, damage = 0.75},
            {threshold = 95.0, screenEffect = {value = "InchPurple02", intensity = 1.4}, blockJumping = true, damage = 1.5},
        },
    },

    -- Inhalants: brief rush with dizziness, heavy impairment, and oxygen/toxicity danger
    ["inhalant"] = {
        value = {
            drain = 0.2,
        },
        effect = {
            {threshold = 5.0, screenEffect = {value = "BikerFilter", intensity = 0.8}},
            {threshold = 20.0, screenEffect = {value = "BikerFilter", intensity = 0.9}, walkingStyle = "move_m@buzzed"},
            {threshold = 45.0, screenEffect = {value = "BikerFilter", intensity = 1.1}, cameraShaking = {value = "DRUNK_SHAKE", intensity = 0.2}, blurryVision = true},
            {threshold = 70.0, screenEffect = {value = "BikerFilter", intensity = 1.2}, walkingStyle = "move_m@drunk@verydrunk", blockSprinting = true, blockJumping = true, damage = 1.0},
            {threshold = 95.0, screenEffect = {value = "BikerFilter", intensity = 1.3}, damage = 2.0},
        },
    },
}