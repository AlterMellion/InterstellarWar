local enemyShips = {}

require("math")
local helper = require("helper")
local animation = require("animation")
local score = require("score")
local enemyShip = require("enemyShip")

local maxEnemiesOnScreen = 3
local enemyTimer = 0
local enemyFrequencyMax = 2.5
local speedBoost = 0
local increaseDifficulty = true
local enemyShipsTable

local spriteWidth = 92
local spriteHeight = 67

function enemyShips.load()
    enemyShipsTable = {}
end

function enemyShips.spawn(dt)
    enemyTimer = enemyTimer + dt
    local enemyFrequency = math.random(0.5, enemyFrequencyMax)
    if #enemyShipsTable < maxEnemiesOnScreen and enemyTimer > enemyFrequency then
        table.insert(enemyShipsTable, enemyShip.init())
        enemyTimer = 0
    end
end

function enemyShips.move(dt, spaceship)
    local currentScore = score.getValue()
    if increaseDifficulty and currentScore > 0 and currentScore % 10 == 0 then
        local result = math.random(1, 3)
        if result == 1 then
            maxEnemiesOnScreen = maxEnemiesOnScreen + 1
            print("Increase max enemies on screen:"..maxEnemiesOnScreen)
        elseif result == 2 then
            speedBoost = currentScore
            print("Increase enemies speedboost: +"..speedBoost)
        else
            enemyFrequencyMax = enemyFrequencyMax - 0.25
            print("Reduce max frequency by -0.25: "..enemyFrequencyMax)
        end
        increaseDifficulty = false
    end

    if not increaseDifficulty and currentScore > 0 and currentScore % 10 ~= 0 then
        increaseDifficulty = true
    end

    for i=#enemyShipsTable, 1, -1 do
        enemyShipsTable[i].currentTime = enemyShipsTable[i].currentTime + dt
        if enemyShipsTable[i].currentTime >= enemyShipsTable[i].duration then
            enemyShipsTable[i].currentTime = enemyShipsTable[i].currentTime - enemyShipsTable[i].duration
        end

        enemyShipsTable[i].y = enemyShipsTable[i].y + (enemyShipsTable[i].speed + speedBoost) * dt
        if enemyShipsTable[i].y > ScreenHeight + spriteHeight then
            table.remove(enemyShipsTable, i)
        else
            local distance = helper.distanceBetweenTwoObjects(enemyShipsTable[i].x, enemyShipsTable[i].y, spaceship.x, spaceship.y)
            if distance < spriteWidth/2 then
                spaceship.updateLifes(-1)
                do break end
            end
        end
    end
end

function enemyShips.draw()
    for i, enemy in ipairs(enemyShipsTable) do
        enemyShip.draw(enemy)
    end
end

function enemyShips.getTable()
    return enemyShipsTable
end

function enemyShips.reset()
    enemyShipsTable = {}
end

return enemyShips