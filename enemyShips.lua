local enemyShips = {}

require("math")
local helper = require("helper")
local animation = require("animation")
local score = require("score")

local maxEnemiesOnScreen = 3
local enemyPic
local enemyTimer = 0
local enemyFrequencyMax = 2.5
local speedBoost = 0
local increaseDifficulty = true
local enemyAnim

local spriteWidth = 92
local spriteHeight = 67

function enemyShips.load()
    enemyPic = love.graphics.newImage("pics/enemyShipAnim.png")
    enemyAnim = animation.new(enemyPic, spriteWidth, spriteHeight, 0.25)
end

function enemyShips.init()
    math.randomseed(os.time())
    math.random()

    local enemyShip = {
        speed = math.random(120, 150),
        x = math.random(spriteWidth, screenWidth - spriteWidth),
        y = 0 - spriteHeight,
        currentTime = 0,
        duration = enemyAnim.duration,
        quads = enemyAnim.quads,
        spriteSheet = enemyAnim.spriteSheet,
        spriteWidth = spriteWidth
    }
    return enemyShip
end

function enemyShips.spawn(dt)
    enemyTimer = enemyTimer + dt
    local enemyFrequency = math.random(0.5, enemyFrequencyMax)
    if #enemyShips < maxEnemiesOnScreen and enemyTimer > enemyFrequency then
        table.insert(enemyShips, enemyShips.init())
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

    for i=#enemyShips, 1, -1 do
        enemyShips[i].currentTime = enemyShips[i].currentTime + dt
        if enemyShips[i].currentTime >= enemyShips[i].duration then
            enemyShips[i].currentTime = enemyShips[i].currentTime - enemyShips[i].duration
        end

        enemyShips[i].y = enemyShips[i].y + (enemyShips[i].speed + speedBoost) * dt
        if enemyShips[i].y > screenHeight + spriteHeight then
            table.remove(enemyShips, i)
        else
            local distance = helper.distanceBetweenTwoObjects(enemyShips[i].x, enemyShips[i].y, spaceship.x, spaceship.y)
            if distance < spriteWidth/2 then
                spaceship.updateLifes(-1)
                do break end
            end
        end
    end
end

function enemyShips.draw()
    for i, enemyShip in ipairs(enemyShips) do
        animation.play(enemyShip, enemyShip.x, enemyShip.y, spriteWidth/2, spriteHeight/2)
    end
end

return enemyShips