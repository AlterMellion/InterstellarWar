local playerShots = {}

local explosions = require("explosions")
local helper = require("helper")
local score = require("score")

local basicShotPic
local shotSpeed = 200
local explosionAnim

function playerShots.load()
    basicShotPic = love.graphics.newImage("pics/basicShot.png")
    explosionAnim = explosions.getAnimation()
end

function playerShots.draw()
    for i, shot in ipairs(playerShots) do
        helper.drawCenter(basicShotPic, shot.x, shot.y)
    end
end

function playerShots.shoot(spaceship)
    local shot = {
        x = spaceship.x,
        y = spaceship.y - basicShotPic:getHeight()
    }
    table.insert(playerShots, shot)
end

function playerShots.move(dt, enemyShips, minimumRange)
    for i=#playerShots, 1, -1 do
        local currentShot = playerShots[i] 
        currentShot.y = currentShot.y - shotSpeed * dt

        if currentShot.y < 0 - basicShotPic:getHeight() then
            table.remove(playerShots, i)
            do break end
        else
            for j=#enemyShips, 1, -1 do
                local currentEnemy = enemyShips[j]
                local distance = helper.distanceBetweenTwoObjects(currentEnemy.x, currentEnemy.y, currentShot.x, currentShot.y)
                
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
                    score.update(1)
                    break
                end
            end
        end
    end
end

return playerShots