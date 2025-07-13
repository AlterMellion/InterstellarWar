local endScreen = {}

local helper = require("helper")

local music
local victoryMessage = "VICTORY!"
local victoryMsgPosY = ScreenHeight/2
local isLoaded = false

local creditsArray = {}
local displayCreditsArray= {}
local startRollingCredits = 2
local timeBetweenLines = 1
local currentTime = 0
local fontHeight

function endScreen.load()
    endScreen = love.graphics.newImage("pics/endGame.png")
    music = love.audio.newSource("audio/kim-lightyear-legends-109307.mp3", "static")
    music:setLooping(true)
    music:play()
    isLoaded = true
    
    local font = love.graphics.getFont()
    fontHeight = font:getHeight()

    local creditsContent = love.filesystem.read( "credits.txt" )
    local creditsContentArray = helper.SplitStringIntoArray(creditsContent)
    for i, line in ipairs(creditsContentArray) do
        local line = {
            y = ScreenHeight + fontHeight,
            text = line
        }
       table.insert(creditsArray, line)
    end
end

function endScreen.update(dt)
    currentTime = currentTime + dt
    if victoryMsgPosY + fontHeight < 0 then
        if currentTime >= timeBetweenLines then
            table.insert(displayCreditsArray, creditsArray[1])
            table.remove(creditsArray, 1)
            currentTime = 0
        end
        for i, line in ipairs(displayCreditsArray) do
            line.y = line.y - 1
        end
    else
        if currentTime >= startRollingCredits then
            victoryMsgPosY = victoryMsgPosY - 1
        end
    end
end

function endScreen.draw()
    love.graphics.draw(endScreen, 0, 0)

    if victoryMsgPosY + fontHeight < 0 then
        for i, line in ipairs(displayCreditsArray) do
            helper.outlineText(line.text, 0, line.y)
        end
    else
        helper.outlineText(victoryMessage, 0, victoryMsgPosY)
    end
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

function endScreen.creditsEnd()
    if #displayCreditsArray == 0 then
        return false
    end

    if displayCreditsArray[#displayCreditsArray].y + fontHeight < 0 then
        return true
    end

    return false
end

return endScreen