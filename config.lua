local config = {}

local json = require("json")
local decodedConfig

function config.load()
    local configJson = love.filesystem.read( "config.json" )
    decodedConfig = json.decode(configJson)
end

function config.get()
    return decodedConfig
end

return config