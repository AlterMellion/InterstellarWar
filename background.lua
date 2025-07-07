local background = {}

local scrollingSpeed = 25
local y = 0
local level1Music
local gameOverMusic

function background.load()
    background = love.graphics.newImage("pics/spaceBackground.jpg")
    level1Music = love.audio.newSource("audio/hyperion-hypercube-355494.mp3", "static")
    level1Music:setLooping(true)
    level1Music:stop()
    level1Music:play()

    gameOverMusic = love.audio.newSource("audio/quiz-countdown-194417.mp3", "static")
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

function background.stopMusic()
    level1Music:stop()
end

function background.playGameOverTheme()
    gameOverMusic:play()
end

return background