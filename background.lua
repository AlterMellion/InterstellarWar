local background = {}

local scrollingSpeed = 25
local y = 0
local sound

function background.load()
    background = love.graphics.newImage("pics/spaceBackground.jpg")
    sound = love.audio.newSource("audio/hyperion-hypercube-355494.mp3", "static")
    sound:setLooping(true)
    sound:stop()
    sound:play()
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