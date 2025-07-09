local startScreen = {}

local music

function startScreen.load()
    startScreen = love.graphics.newImage("pics/startMenu2.png")
    music = love.audio.newSource("audio/16-bits-musica-294099.mp3", "static")
    music:setLooping(true)
    music:play()
end

function startScreen.draw()
    love.graphics.draw(startScreen, 0, 0)
    love.graphics.printf("PRESS ENTER", 0, screenHeight / 2, screenWidth, "center")
end

function startScreen.startMusic()
    music:play()
end

function startScreen.stopMusic()
    music:stop()
end

return startScreen