local continue = {}

local helper = require("helper")

local continueMessage
local font
local maxCountdown = 10
local countdownNumber = maxCountdown

function continue.load()
    continueMessage = "CONTINUE?"
end

function continue.updateCountdown()
    countdownNumber = countdownNumber - 1
end

function continue.draw()
    if countdownNumber >= 0 then
        local screenHeight = love.graphics.getHeight()
        helper.outlineText(continueMessage, 0, (screenHeight / 2) + 50)
        helper.outlineText(countdownNumber, 0, (screenHeight / 2) + 100)

    end
end

function continue.countdownNumber()
    return countdownNumber
end

function continue.resetCountdown()
    countdownNumber = maxCountdown
end

return continue