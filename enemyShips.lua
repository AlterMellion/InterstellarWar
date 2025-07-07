local enemyShips = {}

local helper = require("helper")

local maxEnemiesOnScreen = 3
local enemyPic
local enemyTimer = 0
local enemyFrequency = 2

function enemyShips.load()
    enemyPic = love.graphics.newImage("pics/enemyShip.png")
end

function enemyShips.getPicWidth()
    return enemyPic:getWidth()
end

function enemyShips.init()
    local enemyShip = {}
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

function enemyShips.move(dt)
    for i=#enemyShips, 1, -1 do
        enemyShips[i].y = enemyShips[i].y + enemyShips[i].speed * dt

        if enemyShips[i].y > screenHeight + enemyPic:getHeight() then
            table.remove(enemyShips, i)
        end
    end
end

function enemyShips.draw()
    for i, enemyShip in ipairs(enemyShips) do
        helper.drawCenter(enemyShip.pic, enemyShip.x, enemyShip.y)
    end
end

return enemyShips