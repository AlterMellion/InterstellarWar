local enemyShips = {}

require("math")
local helper = require("helper")
local score = require("score")

local maxEnemiesOnScreen = 3
local enemyPic
local enemyTimer = 0
local enemyFrequency = 2
local speedBoost = 0

function enemyShips.load()
    enemyPic = love.graphics.newImage("pics/enemyShip.png")
end

function enemyShips.getPicWidth()
    return enemyPic:getWidth()
end

function enemyShips.init()
    local enemyShip = {}
    math.randomseed(os.time())
    math.random() 
    enemyShip.speed = math.random(120, 150)
    enemyShip.pic = enemyPic
    enemyShip.x = math.random(enemyShip.pic:getWidth(), screenWidth - enemyShip.pic:getWidth())
    enemyShip.y = 0 - enemyShip.pic:getHeight()
    return enemyShip
end

function enemyShips.spawn(dt)
    enemyTimer = enemyTimer + dt
    if #enemyShips < maxEnemiesOnScreen and enemyTimer > enemyFrequency then
        table.insert(enemyShips, enemyShips.init())
        enemyTimer = 0
        enemyFrequency = math.random(1, 3)
    end
end

function enemyShips.move(dt, spaceship)
    local currentScore = score.getValue()
    if currentScore % 10 == 0 then
        speedBoost = currentScore
    end

    for i=#enemyShips, 1, -1 do
        enemyShips[i].y = enemyShips[i].y + (enemyShips[i].speed + speedBoost) * dt
        if enemyShips[i].y > screenHeight + enemyPic:getHeight() then
            table.remove(enemyShips, i)
        else
            local distance = helper.distanceBetweenTwoObjects(enemyShips[i].x, enemyShips[i].y, spaceship.x, spaceship.y)
            if distance < enemyPic:getWidth() / 2 then
                spaceship.updateLifes(-1)
                do break end
            end
        end
    end
end

function enemyShips.draw()
    for i, enemyShip in ipairs(enemyShips) do
        helper.drawCenter(enemyShip.pic, enemyShip.x, enemyShip.y)
    end
end

return enemyShips