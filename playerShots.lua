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

local maxShotsBeforeOverHeat = 10
local currentShots = 0
local weaponOverHeated = false
local coolDownSpeed = 2
local weaponIcon
local weaponState

function playerShots.load()
    basicShotPic = love.graphics.newImage("pics/basicShotAnim.png")
    shotAnim = animation.new(basicShotPic, spriteWidth, spriteHeight, 0.25)

    shotSound = love.audio.newSource("audio/laserShoot.wav", "static")
    overheatSound = love.audio.newSource("audio/overheat.wav", "static")

    weaponIcon = animation.new(love.graphics.newImage("pics/weaponOverheatIcon.png"), 195, 40, 1)
end

function playerShots.draw()
    for i, shot in ipairs(playerShots) do
        animation.play(shot, shot.x, shot.y, spriteWidth/2, spriteHeight/2)
    end

    if currentShots >= 0 and currentShots < maxShotsBeforeOverHeat * 0.70 then
        weaponState = 1
    elseif currentShots >= maxShotsBeforeOverHeat * 0.70 and currentShots < maxShotsBeforeOverHeat * 0.90 then
        weaponState = 2
    elseif (currentShots >= maxShotsBeforeOverHeat * 0.90 and currentShots <= maxShotsBeforeOverHeat) or weaponOverHeated then
        weaponState = 3
    end
    love.graphics.draw(weaponIcon.spriteSheet, weaponIcon.quads[weaponState], ScreenWidth - (195 * 0.5) - 20, 50, 0, 0.5, 0.5)
end

function playerShots.shoot(spaceship)
    if not weaponOverHeated then
        currentShots = currentShots + 1
        local shot = {
            x = spaceship.x,
            y = spaceship.y - basicShotPic:getHeight(),
            currentTime = 0,
            duration = shotAnim.duration,
            quads = shotAnim.quads,
            spriteSheet = shotAnim.spriteSheet,
            spriteWidth = spriteWidth,
            weaponIcon = weaponIcon
        }
        table.insert(playerShots, shot)
        shotSound:stop()
        shotSound:play()
    end

    if currentShots >= maxShotsBeforeOverHeat then
        weaponOverHeated = true
    else
        weaponOverHeated = false
    end

    if weaponOverHeated then
        overheatSound:play()
    end
end

function playerShots.update(dt, enemyShipsTable)
    if currentShots > 0 then
        currentShots = currentShots - (coolDownSpeed * dt)
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
                if enemyShipsTable[j].isHit then
                    enemyShipsTable[j].hitTimer = enemyShipsTable[j].hitTimer + dt
                    if enemyShipsTable[j].hitTimer > enemyShipsTable[j].hitDuration then
                        enemyShipsTable[j].isHit = false
                        enemyShipsTable[j].hitTimer = 0
                    end
                end
                
                local currentEnemy = enemyShipsTable[j]
                local distance = helper.distanceBetweenTwoObjects(currentEnemy.x, currentEnemy.y, playerShots[i].x, playerShots[i].y)

                if not enemyShipsTable[j].isHit and distance < enemyShip.getSpriteWidth(enemyShipsTable[j])/2 then
                    enemyShipsTable[j].lifes = enemyShipsTable[j].lifes - 1
                    
                    if enemyShipsTable[j].lifes == 0 then
                        explosions.add(currentEnemy.x, currentEnemy.y, 1)
                        table.remove(enemyShipsTable, j)
                        table.remove(playerShots, i)
                        if not IsGameOver then
                            score.update(1)
                        end
                        break
                    else
                        explosions.add(currentEnemy.x, currentEnemy.y, 0.15)
                        enemyShipsTable[j].hurtSound:play()
                        enemyShipsTable[j].isHit = true
                        table.remove(playerShots, i)
                        break
                    end
                end
            end
        end
    end
end

return playerShots