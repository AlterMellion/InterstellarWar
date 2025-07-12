local startScreen = {}

local helper = require("helper")

local music
local pressEnterMsg = "PRESS ENTER"
local hideText = false
local currentTime = 0
local blinkDuration = 0.5

function startScreen.load()
    startScreen = love.graphics.newImage("pics/startMenu2.png")
    music = love.audio.newSource("audio/16-bits-musica-294099.mp3", "static")
    music:setLooping(true)
    music:play()
end

function startScreen.draw()
    love.graphics.draw(startScreen, 0, 0)

    if hideText then
        helper.outlineText(pressEnterMsg, 0, (ScreenHeight / 2))
    end
end

function startScreen.update(dt)
    currentTime = currentTime + dt
    if currentTime >= blinkDuration then
        if hideText then
            hideText = false
            currentTime = 0
            return
        end
            
        hideText = true
        currentTime = 0
    end
end

function startScreen.startMusic()
    music:play()
end

function startScreen.stopMusic()
    music:stop()
end

return startScreen