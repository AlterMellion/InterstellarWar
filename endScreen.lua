local endScreen = {}

local music
local victoryMessage = "VICTORY!"
local isLoaded = false
local font

function endScreen.load()
    endScreen = love.graphics.newImage("pics/endGame.png")
    music = love.audio.newSource("audio/kim-lightyear-legends-109307.mp3", "static")
    music:setLooping(true)
    music:play()
    isLoaded = true
end

function endScreen.draw()
    love.graphics.draw(endScreen, 0, 0)

    --outlines text
    love.graphics.setColor(0,0,0)
    love.graphics.printf(victoryMessage, 0, (ScreenHeight/2) - 2, ScreenWidth - 2, "center")
    love.graphics.printf(victoryMessage, 0, (ScreenHeight/2) + 2, ScreenWidth + 2, "center")

    love.graphics.setColor(1,1,1)
    love.graphics.printf(victoryMessage, 0, ScreenHeight/2, ScreenWidth, "center")
end

function endScreen.startMusic()
    music:play()
end

function endScreen.stopMusic()
    music:stop()
end

function endScreen.isLoaded()
    return isLoaded
end

return endScreen