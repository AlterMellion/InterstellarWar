local gameover = {}

local helper = require("helper")

local message

function gameover.load()
    message = "GAME OVER"
end

function gameover.draw()
    local screenHeight = love.graphics.getHeight()
    helper.outlineText(message, 0, (screenHeight / 2))
end

return gameover