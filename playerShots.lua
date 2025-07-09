local playerShots = {}

local explosions = require("explosions")
local helper = require("helper")
local score = require("score")
local animation = require("animation")

local basicShotPic
local shotSpeed = 200
local explosionAnim
local sound

local shotAnim
local spriteWidth = 28
local spriteHeight = 66

local wasHit = false

function playerShots.load()
    basicShotPic = love.graphics.newImage("pics/basicShotAnim.png")
    shotAnim = animation.new(basicShotPic, spriteWidth, spriteHeight, 0.25)

    explosionAnim = explosions.getAnimation()

    sound = love.audio.newSource("audio/laserShoot.wav", "static")
end

function playerShots.draw()
    for i, shot in ipairs(playerShots) do
        animation.play(shot, shot.x, shot.y, spriteWidth/2, spriteHeight/2)
    end
end

function playerShots.shoot(spaceship)
    local shot = {
        x = spaceship.x,
        y = spaceship.y - basicShotPic:getHeight(),
        currentTime = 0,
        duration = shotAnim.duration,
        quads = shotAnim.quads,
        spriteSheet = shotAnim.spriteSheet,
        spriteWidth = spriteWidth
    }
    table.insert(playerShots, shot)
    sound:stop()
    sound:play()
end

function playerShots.move(dt, enemyShips)
    for i=#playerShots, 1, -1 do
        playerShots[i].currentTime = playerShots[i].currentTime + dt
        if playerShots[i].currentTime >= playerShots[i].duration then
            playerShots[i].currentTime = playerShots[i].currentTime - playerShots[i].duration
        end

        local currentShot = playerShots[i] 
        currentShot.y = currentShot.y - shotSpeed * dt

        if currentShot.y < 0 - basicShotPic:getHeight() then
            table.remove(playerShots, i)
            do break end
        else
            for j=#enemyShips, 1, -1 do
                local currentEnemy = enemyShips[j]
                local distance = helper.distanceBetweenTwoObjects(currentEnemy.x, currentEnemy.y, currentShot.x, currentShot.y)
                
                if enemyShips[i] ~= nil and distance < enemyShips[i].spriteWidth/2 then   
                    explosions.add(currentEnemy.x, currentEnemy.y)
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