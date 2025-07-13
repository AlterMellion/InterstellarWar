local playerShots = {}

local explosions = require("explosions")
local helper = require("helper")
local score = require("score")
local animation = require("animation")
local enemyShip = require("enemyShip")
local boss = require("boss")
local audio = require("audio")

local basicShotPic
local shotSpeed = 200
local shotSound
local overheatSound

local shotAnim
local numberOfSprites = 3
local spriteWidth
local spriteHeight

local maxShotsBeforeOverHeat = 10
local currentShots = 0
local weaponOverHeated = false
local coolDownSpeed = 2
local weaponIcon
local weaponState

function playerShots.load()
    basicShotPic = love.graphics.newImage("pics/basicShotAnim.png")
    spriteWidth = basicShotPic:getWidth()/numberOfSprites
    spriteHeight = basicShotPic:getHeight()
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

function playerShots.update(dt, enemyShipsTable, bossInstance)
    if currentShots > 0 then
        currentShots = currentShots - (coolDownSpeed * dt)
    end

    for i=#playerShots, 1, -1 do
        -- Shot animation
        animation.update(playerShots[i], dt)

        -- Shot move up
        playerShots[i].y = playerShots[i].y - shotSpeed * dt

        if playerShots[i].y < 0 - basicShotPic:getHeight() then
            table.remove(playerShots, i)
            do break end
        else
            if bossInstance ~= nil then
                bossInstance.hitTimer = bossInstance.hitTimer + dt
                if bossInstance.hitTimer > bossInstance.hitDuration then
                    bossInstance.isHit = false
                    bossInstance.hitTimer = 0
                end

                local distance = helper.distanceBetweenTwoObjects(bossInstance.x, bossInstance.y, playerShots[i].x, playerShots[i].y)
                
                if distance < bossInstance.spriteWidth/3 and not bossInstance.isHit then
                    explosions.add(playerShots[i].x, playerShots[i].y, 0.15)
                    table.remove(playerShots, i)
                    audio.playHurtSound()
                    boss.decreaseLifes(dt)
                    bossInstance.isHit = true
                end
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
                            audio.playHurtSound()
                            enemyShipsTable[j].isHit = true
                            table.remove(playerShots, i)
                            break
                        end
                    end
                end
            end
        end
    end
end

return playerShots