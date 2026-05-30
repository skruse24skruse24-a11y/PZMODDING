local State = {
    initialized = false,
    zombieUpdates = 0,
    nextHeartId = 1,

    initiator = {
        zombieKey = nil,
        phase = "searching",
        ticksInPhase = 0,
        swarmFollowers = {},
    },

    heart = {
        id = nil,
        active = false,
        stage = 1,
        biomass = 0,
        absorbProgress = 0,
        absorbedCount = 0,
        expansionCells = 1,
        spentBiomassOnExpansion = 0,
        builtStructures = {
            storageCell = false,
            podI = false,
            deconstructor = false,
        },
        knownZombieKeys = {},
    },
}

return State
