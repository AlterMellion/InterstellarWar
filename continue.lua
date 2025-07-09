local continue = {}

local continueMessage
local font
local maxCountdown = 10
local countdownNumber = maxCountdown

function continue.load()
    font = love.graphics.newFont("fonts/pixelmix.ttf", 35)
    love.graphics.setFont(font)
    continueMessage = "CONTINUE?"
end

function continue.updateCountdown()
    countdownNumber = countdownNumber - 1
end

function continue.draw()
    if countdownNumber >= 0 then
        love.graphics.printf(continueMessage, 0, screenHeight / 2 - font:getHeight() / 2 + 50, screenWidth, "center")
        love.graphics.printf(countdownNumber, 0, screenHeight / 2 - font:getHeight() / 2 + 100, screenWidth, "center")
    end
end

function continue.countdownNumber()
    return countdownNumber
end

function continue.resetCountdown()
    countdownNumber = maxCountdown
end

return continue