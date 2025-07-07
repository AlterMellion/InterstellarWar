local gameover = {}

local message
local font

function gameover.load()
    font = love.graphics.newFont("fonts/pixelmix.ttf", 35)
    love.graphics.setFont(font)
    message = "GAME OVER"
end

function gameover.draw()
    love.graphics.printf(message, 0, screenHeight / 2 - font:getHeight() / 2, screenWidth, "center")
end

return gameover