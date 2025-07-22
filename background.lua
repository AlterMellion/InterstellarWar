local background = {}

local helper = require("helper")

local scrollingSpeed = 25
local y = 0
local level1Music
local gameOverMusic

local displayDuration = 0
local maxDisplayDuration = 5
local displayLevelName = true
local currentLevel

function background.load(level)
    background = love.graphics.newImage("levelsassets/level"..level.."/background/pic/spaceBackground.jpg")
    level1Music = love.audio.newSource("levelsassets/level"..level.."/background/audio/hyperion-hypercube-355494.mp3", "static")
    level1Music:setLooping(true)
    gameOverMusic = love.audio.newSource("audio/quiz-countdown-194417.mp3", "static")

    currentLevel = level
end

function background.draw()
    love.graphics.draw(background, 0, y)
    love.graphics.draw(background, 0, y - background:getHeight())

    if displayLevelName then
        local screenHeight = love.graphics.getHeight()
        helper.outlineText("LEVEL "..currentLevel, 0, (screenHeight / 2))
    end
end

function background.scroll(dt)
    displayDuration = displayDuration + dt
    if displayDuration > maxDisplayDuration then
        displayLevelName = false
    end

    y = y + scrollingSpeed * dt
    if y >= background:getHeight() then
        y = 0
    end
end

function background.startMusic()
    level1Music:play()
end

function background.stopMusic()
    level1Music:stop()
end

function background.startGameOverTheme()
    gameOverMusic:play()
end

function background.stopGameOverTheme()
    gameOverMusic:stop()
end

function background.IsLevelNameDisplayed()
    return displayLevelName
end

return background