local playerShots = {}

local explosions = require("explosions")

local basicShotPic
local shotSpeed = 200
local explosionAnim

function playerShots.load()
    basicShotPic = love.graphics.newImage("pics/basicShot.png")
    explosionAnim = explosions.getAnimation()
end

function playerShots.displayPlayerShots()
    for i, shot in ipairs(playerShots) do
        drawCenter(basicShotPic, shot.x, shot.y)
    end
end

function playerShots.fireShot(spaceship)
    local shot = {
        x = spaceship.x,
        y = spaceship.y - basicShotPic:getHeight()
    }
    table.insert(playerShots, shot)
end

function playerShots.moveShots(dt, enemyShips, minimumRange)
    for i=#playerShots, 1, -1 do
        local currentShot = playerShots[i] 
        currentShot.y = currentShot.y - shotSpeed * dt

        if currentShot.y < 0 - basicShotPic:getHeight() then
            table.remove(playerShots, i)
            do break end
        else
            for j=#enemyShips, 1, -1 do
                local currentEnemy = enemyShips[j]
                local distance = distanceBetweenTwoObjects(currentEnemy.x, currentEnemy.y, currentShot.x, currentShot.y)
                
                if distance < minimumRange then
                    local explosion = {
                        x = currentEnemy.x,
                        y = currentEnemy.y,
                        currentTime = 0,
                        duration = explosionAnim.duration,
                        quads = explosionAnim.quads,
                        spriteSheet = explosionAnim.spriteSheet
                    }
                    table.insert(explosions, explosion)
                    table.remove(enemyShips, j)
                    table.remove(playerShots, i)
                    break
                end
            end
        end
    end
end

return playerShots