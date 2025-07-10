local startScreen = {}

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
        --outlines text
        love.graphics.setColor(0,0,0)
        love.graphics.printf(pressEnterMsg, 0, (screenHeight / 2) - 2, screenWidth - 2, "center")
        love.graphics.printf(pressEnterMsg, 0, (screenHeight / 2) + 2, screenWidth + 2, "center")

        love.graphics.setColor(1,1,1)
        love.graphics.printf(pressEnterMsg, 0, screenHeight / 2, screenWidth, "center")
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