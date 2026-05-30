local Config = require "MyFirstPZMod/Config"

local Logger = {}

function Logger.info(channel, message)
    if not Config.debug.enabled then
        return
    end

    print("[" .. Config.modId .. "][" .. channel .. "] " .. message)
end

return Logger
