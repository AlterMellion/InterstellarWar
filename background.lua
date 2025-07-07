local background = {}

local scrollingSpeed = 25
local y = 0

function background.load()
    background = love.graphics.newImage("pics/spaceBackground.jpg")
end

function background.draw()
    love.graphics.draw(background, 0, y)
    love.graphics.draw(background, 0, y - background:getHeight())
end

function background.scroll(dt)
    y = y + scrollingSpeed * dt
    if y >= background:getHeight() then
        y = 0
    end
end

return background