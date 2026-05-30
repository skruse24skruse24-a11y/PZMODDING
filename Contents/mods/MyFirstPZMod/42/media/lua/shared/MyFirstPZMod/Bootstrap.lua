local Config = require "MyFirstPZMod/Config"
local Simulation = require "MyFirstPZMod/Simulation"

print("[" .. Config.modId .. "] shared bootstrap loaded")

-- Verified against PZwiki Lua API: Events.OnZombieUpdate.Add(callback)
local function onZombieUpdate(zombie)
	Simulation.onZombieUpdate(zombie)
end

---@diagnostic disable-next-line: undefined-global
Events.OnZombieUpdate.Add(onZombieUpdate)

-- Debug helpers for manual testing in Lua console.
_G.MyFirstPZModDebug = _G.MyFirstPZModDebug or {}
_G.MyFirstPZModDebug.getSnapshot = function()
	return Simulation.getSnapshot()
end
_G.MyFirstPZModDebug.reset = function()
	Simulation.resetPrototype()
end
_G.MyFirstPZModDebug.addBiomass = function(amount)
	local value = tonumber(amount) or 0
	return Simulation.forceBiomass(value)
end
