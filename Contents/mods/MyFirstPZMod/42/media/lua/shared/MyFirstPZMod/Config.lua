local Config = {}

Config.modId = "MyFirstPZMod"

Config.debug = {
    enabled = true,
    logEveryNZombieUpdates = 200,
}

Config.prototype = {
    -- Number of zombie update callbacks before the glowing initiator converts.
    initiatorToHeartTicks = 300,

    -- Maximum tracked swarm followers while in the Swarming phase.
    maxSwarmFollowers = 20,

    -- Number of zombie update callbacks required to absorb one zombie.
    absorbTicksPerZombie = 120,

    -- Biomass added per completed absorption.
    biomassPerAbsorption = 10,

    -- Biomass required to claim one expansion cell in the abstract nest grid.
    biomassPerExpansionCell = 15,

    -- Biomass checkpoints used to advance heart stage.
    stage2Biomass = 80,
    stage3Biomass = 180,

    -- Structures are built when biomass reaches these checkpoints.
    structureThresholds = {
        storageCell = 40,
        podI = 100,
        deconstructor = 160,
    },
}

return Config
