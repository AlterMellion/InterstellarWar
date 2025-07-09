local playerShots = {}

local explosions = require("explosions")
local helper = require("helper")
local score = require("score")
local animation = require("animation")
local enemyShip = require("enemyShip")

local basicShotPic
local shotSpeed = 200
local shotSound
local overheatSound

local shotAnim
local spriteWidth = 28
local spriteHeight = 66

local maxShotsBeforeOverHeat = 5
local currentShots = 0
local eaponOverHeated = false
local timeSinceOverHeat = 0
local weaponCoolDown = 1

function playerShots.load()
    basicShotPic = love.graphics.newImage("pics/basicShotAnim.png")
    shotAnim = animation.new(basicShotPic, spriteWidth, spriteHeight, 0.25)

    shotSound = love.audio.newSource("audio/laserShoot.wav", "static")
    overheatSound = love.audio.newSource("audio/overheat.wav", "static")
end

function playerShots.draw()
    for i, shot in ipairs(playerShots) do
        animation.play(shot, shot.x, shot.y, spriteWidth/2, spriteHeight/2)
    end
end

function playerShots.isWeaponCooledDown(dt)
    timeSinceOverHeat = timeSinceOverHeat + dt
    if timeSinceOverHeat >= weaponCoolDown then
        eaponOverHeated = false
        currentShots = 0
        timeSinceOverHeat = 0
    else
        overheatSound:play()
    end
end

function playerShots.shoot(spaceship)
    if not eaponOverHeated then
        currentShots = currentShots + 1
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
        shotSound:stop()
        shotSound:play()
    end

    if currentShots == maxShotsBeforeOverHeat then
        eaponOverHeated = true
    end
end

function playerShots.update(dt, enemyShipsTable)
    if eaponOverHeated then
        playerShots.isWeaponCooledDown(dt)
    end

    for i=#playerShots, 1, -1 do
        playerShots[i].currentTime = playerShots[i].currentTime + dt
        if playerShots[i].currentTime >= playerShots[i].duration then
            playerShots[i].currentTime = playerShots[i].currentTime - playerShots[i].duration
        end

        playerShots[i].y = playerShots[i].y - shotSpeed * dt

        if playerShots[i].y < 0 - basicShotPic:getHeight() then
            table.remove(playerShots, i)
            do break end
        else
            for j=1, #enemyShipsTable, 1 do
                local currentEnemy = enemyShipsTable[j]
                local distance = helper.distanceBetweenTwoObjects(currentEnemy.x, currentEnemy.y, playerShots[i].x, playerShots[i].y)

                if enemyShipsTable[i] ~= nil and distance < enemyShip.getSpriteWidth(enemyShipsTable[i])/2 then
                    explosions.add(currentEnemy.x, currentEnemy.y)
                    table.remove(enemyShipsTable, j)
                    table.remove(playerShots, i)
                    score.update(1)
                    break
                end
            end
        end
    end
end

return playerShots