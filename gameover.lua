local gameover = {}

local message
local font

function gameover.load()
    message = "GAME OVER"
end

function gameover.draw()
    love.graphics.printf(message, 0, ScreenHeight / 2 - font:getHeight() / 2, ScreenWidth, "center")
end

return gameover