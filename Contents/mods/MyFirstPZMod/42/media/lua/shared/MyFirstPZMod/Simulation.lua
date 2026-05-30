local Config = require "MyFirstPZMod/Config"
local Logger = require "MyFirstPZMod/Logger"
local State = require "MyFirstPZMod/State"

local Simulation = {}

local function toZombieKey(zombie)
    return tostring(zombie)
end

local function countKeys(map)
    local count = 0
    for _ in pairs(map) do
        count = count + 1
    end
    return count
end

local function builtStructureCount(builtStructures)
    local count = 0
    for _, built in pairs(builtStructures) do
        if built then
            count = count + 1
        end
    end
    return count
end

local function initPrototypeIfNeeded(zombie)
    if State.initialized then
        return
    end

    State.initialized = true
    State.initiator.zombieKey = toZombieKey(zombie)
    State.initiator.phase = "swarming"
    State.initiator.ticksInPhase = 0

    Logger.info("Spawn", "Prototype initiator selected: " .. State.initiator.zombieKey)
end

local function updateSwarm(zombieKey)
    local initiator = State.initiator
    if initiator.phase ~= "swarming" then
        return
    end

    initiator.ticksInPhase = initiator.ticksInPhase + 1

    if zombieKey ~= initiator.zombieKey and countKeys(initiator.swarmFollowers) < Config.prototype.maxSwarmFollowers then
        initiator.swarmFollowers[zombieKey] = true
    end

    if initiator.ticksInPhase >= Config.prototype.initiatorToHeartTicks then
        initiator.phase = "converted_to_heart"

        State.heart.id = State.nextHeartId
        State.nextHeartId = State.nextHeartId + 1
        State.heart.active = true
        State.heart.stage = 1
        State.heart.expansionCells = 1
        State.heart.spentBiomassOnExpansion = 0
        State.heart.knownZombieKeys = initiator.swarmFollowers

        Logger.info("Nest", "Initiator converted to Nest Heart id=" .. tostring(State.heart.id))
    end
end

local function updateHeartStage(heart)
    local newStage = 1

    if heart.biomass >= Config.prototype.stage3Biomass then
        newStage = 3
    elseif heart.biomass >= Config.prototype.stage2Biomass then
        newStage = 2
    end

    if newStage ~= heart.stage then
        heart.stage = newStage
        Logger.info("Nest", "Heart id=" .. tostring(heart.id) .. " advanced to stage " .. tostring(heart.stage))
    end
end

local function tryBuildStructures(heart)
    local thresholds = Config.prototype.structureThresholds

    if not heart.builtStructures.storageCell and heart.biomass >= thresholds.storageCell then
        heart.builtStructures.storageCell = true
        Logger.info("Structure", "Heart id=" .. tostring(heart.id) .. " built Storage Cell")
    end

    if not heart.builtStructures.podI and heart.biomass >= thresholds.podI then
        heart.builtStructures.podI = true
        Logger.info("Structure", "Heart id=" .. tostring(heart.id) .. " built Zombie Pod I")
    end

    if not heart.builtStructures.deconstructor and heart.biomass >= thresholds.deconstructor then
        heart.builtStructures.deconstructor = true
        Logger.info("Structure", "Heart id=" .. tostring(heart.id) .. " built Deconstructor")
    end
end

local function updateNestExpansion(heart)
    local availableBiomass = heart.biomass - heart.spentBiomassOnExpansion
    if availableBiomass < Config.prototype.biomassPerExpansionCell then
        return
    end

    local gainedCells = math.floor(availableBiomass / Config.prototype.biomassPerExpansionCell)
    heart.expansionCells = heart.expansionCells + gainedCells
    heart.spentBiomassOnExpansion = heart.spentBiomassOnExpansion + (gainedCells * Config.prototype.biomassPerExpansionCell)

    Logger.info(
        "Nest",
        "Heart id="
            .. tostring(heart.id)
            .. " expanded by "
            .. tostring(gainedCells)
            .. " cells (total="
            .. tostring(heart.expansionCells)
            .. ")"
    )
end

local function resetMap(map)
    for key in pairs(map) do
        map[key] = nil
    end
end

local function updateHeartAbsorption(zombieKey)
    local heart = State.heart
    if not heart.active then
        return
    end

    heart.knownZombieKeys[zombieKey] = true
    heart.absorbProgress = heart.absorbProgress + 1

    if heart.absorbProgress >= Config.prototype.absorbTicksPerZombie then
        heart.absorbProgress = 0
        heart.absorbedCount = heart.absorbedCount + 1
        heart.biomass = heart.biomass + Config.prototype.biomassPerAbsorption

        Logger.info(
            "Biomass",
            "Heart id="
                .. tostring(heart.id)
                .. " absorbed="
                .. tostring(heart.absorbedCount)
                .. " biomass="
                .. tostring(heart.biomass)
        )

        updateHeartStage(heart)
        tryBuildStructures(heart)
        updateNestExpansion(heart)
    end
end

function Simulation.getSnapshot()
    local followerCount = countKeys(State.initiator.swarmFollowers)

    return {
        updates = State.zombieUpdates,
        initiatorPhase = State.initiator.phase,
        followers = followerCount,
        heartActive = State.heart.active,
        heartId = State.heart.id,
        heartStage = State.heart.stage,
        heartBiomass = State.heart.biomass,
        absorbed = State.heart.absorbedCount,
        expansionCells = State.heart.expansionCells,
        structuresBuilt = builtStructureCount(State.heart.builtStructures),
    }
end

function Simulation.forceBiomass(amount)
    local heart = State.heart
    if not heart.active then
        return false, "heart_not_active"
    end

    if amount <= 0 then
        return false, "amount_must_be_positive"
    end

    heart.biomass = heart.biomass + amount
    updateHeartStage(heart)
    tryBuildStructures(heart)
    updateNestExpansion(heart)

    Logger.info("Debug", "Forced biomass +" .. tostring(amount) .. " heartBiomass=" .. tostring(heart.biomass))
    return true, nil
end

function Simulation.resetPrototype()
    State.initialized = false
    State.zombieUpdates = 0
    State.nextHeartId = 1

    State.initiator.zombieKey = nil
    State.initiator.phase = "searching"
    State.initiator.ticksInPhase = 0
    resetMap(State.initiator.swarmFollowers)

    State.heart.id = nil
    State.heart.active = false
    State.heart.stage = 1
    State.heart.biomass = 0
    State.heart.absorbProgress = 0
    State.heart.absorbedCount = 0
    State.heart.expansionCells = 1
    State.heart.spentBiomassOnExpansion = 0
    State.heart.builtStructures.storageCell = false
    State.heart.builtStructures.podI = false
    State.heart.builtStructures.deconstructor = false
    resetMap(State.heart.knownZombieKeys)

    Logger.info("Debug", "Prototype state reset")
end

function Simulation.onZombieUpdate(zombie)
    State.zombieUpdates = State.zombieUpdates + 1

    initPrototypeIfNeeded(zombie)

    local zombieKey = toZombieKey(zombie)

    updateSwarm(zombieKey)
    updateHeartAbsorption(zombieKey)

    if State.zombieUpdates % Config.debug.logEveryNZombieUpdates == 0 then
        local snapshot = Simulation.getSnapshot()
        Logger.info(
            "Perf",
            "updates="
                .. tostring(snapshot.updates)
                .. " phase="
                .. snapshot.initiatorPhase
                .. " followers="
                .. tostring(snapshot.followers)
                .. " heartActive="
                .. tostring(snapshot.heartActive)
                .. " stage="
                .. tostring(snapshot.heartStage)
                .. " biomass="
                .. tostring(snapshot.heartBiomass)
                .. " cells="
                .. tostring(snapshot.expansionCells)
                .. " structures="
                .. tostring(snapshot.structuresBuilt)
        )
    end
end

return Simulation
