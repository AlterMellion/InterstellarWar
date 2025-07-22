local boss = {}

require("math")
local animation = require("animation")
local explosions = require("explosions")
local spaceship = require("spaceship")
local helper = require("helper")
local config = require("config")

local bossAnimSprite
local bossAnim
local bossTheme

local spriteBossWidth
local spriteBossHeight
local bossMoveDirection
local isDestinationReached
local isBossDestroyed
local isBossExploding
local isBossAppearing
local explosionCurrentTime
local scoreThreshold
local numberOfBossSprites
local numberOfShotsSprites
local lifes
local isHit
local hitDuration = 0.1
local bossPicName
local bossAnimationSpeed
local bossThemeName
local scorePoints

local shotPicName
local shotAnimSprite
local spriteShotsWidth
local spriteShotsHeight
local shots = {}
local lastShots = 0
local coolDown = 1
local canonPositions = {}

function boss.loadConfig(level)
    local decodedConfig = config.get()
    
    lifes = decodedConfig["levels"][level]["boss"]["lifes"]
    scoreThreshold = decodedConfig["levels"][level]["boss"]["scoreThreshold"]
    scorePoints = decodedConfig["levels"][level]["boss"]["scorePoints"]

    bossPicName = "levelsassets/level"..level.."/boss/sprite/bossSprite.png"
    numberOfBossSprites = decodedConfig["levels"][level]["boss"]["sprite"]["numberOfSprites"]
    bossAnimationSpeed = decodedConfig["levels"][level]["boss"]["sprite"]["animationSpeed"]

    shotPicName = "levelsassets/level"..level.."/boss/weapon/1/basic/shotAnim.png"
    numberOfShotsSprites = decodedConfig["levels"][level]["boss"]["weapons"][1]["basic"]["numberOfSprites"]
    shotAnimSprite = decodedConfig["levels"][level]["boss"]["weapons"][1]["basic"]["animationSpeed"]

    bossThemeName = decodedConfig["levels"][level]["boss"]["theme"]

    local canonPositionArray = decodedConfig["levels"][level]["boss"]["weapons"][1]["basic"]["canonPositions"]
    for i = 1, #canonPositionArray do
        table.insert(canonPositions, {x = canonPositionArray[i]["x"], y = canonPositionArray[i]["y"]})
    end
    
end

function boss.load()    
    isDestinationReached = false
    isBossDestroyed = false
    isBossExploding = true
    isBossAppearing = true
    explosionCurrentTime = 0
    isHit = false
    shots = {}
    lastShots = 0

    local shotPic = love.graphics.newImage(shotPicName)
    spriteShotsWidth = shotPic:getWidth()/numberOfShotsSprites
    spriteShotsHeight = shotPic:getHeight()
    local bossShotsSprite = animation.new(shotPic, spriteShotsWidth, spriteShotsHeight, shotAnimSprite)

    local bossPic = love.graphics.newImage(bossPicName)
    spriteBossWidth = bossPic:getWidth()/numberOfBossSprites
    spriteBossHeight = bossPic:getHeight()
    bossAnimSprite = animation.new(bossPic, spriteBossWidth, spriteBossHeight, bossAnimationSpeed)
    bossAnim = {
        x = ScreenWidth/2,
        y = 0 - spriteBossHeight,
        duration = bossAnimSprite.duration,
        quads = bossAnimSprite.quads,
        spriteSheet = bossAnimSprite.spriteSheet,
        spriteWidth = spriteBossWidth,
        currentTime = 0,
        hitDuration = hitDuration,
        isHit = isHit,
        hitTimer = 0,
        explodingDuration = 3,
        shotsSprite = {
            duration = bossShotsSprite.duration,
            quads = bossShotsSprite.quads,
            spriteSheet = bossShotsSprite.spriteSheet,
            spriteWidth = spriteShotsWidth,
            currentTime = 0
        }
    }
    bossTheme = love.audio.newSource(bossThemeName, "static")
    
    return bossAnim
end

function boss.update(dt)
    animation.update(bossAnim, dt)

    if bossAnim.y < spriteBossHeight/2 then
        bossAnim.y = bossAnim.y + 100 * dt
    else
        isBossAppearing = false
        lastShots = lastShots + dt
        if lastShots > coolDown and lifes > 0 then
            boss.shoot()
            lastShots = 0
            coolDown = math.random(1, 2.5)
        end

        for i=#shots, 1, -1 do
            animation.update(shots[i], dt)

            shots[i].y = shots[i].y + 100 * dt

            if shots[i].y < 0 - spriteShotsHeight then
                table.remove(shots, i)
                do break end
            else
                local spaceshipPos = spaceship.getPosition()
                local distance = helper.distanceBetweenTwoObjects(spaceshipPos.x, spaceshipPos.y, shots[i].x, shots[i].y)
                if distance < spaceshipPos.width/2 then
                    explosions.add(shots[i].x, shots[i].y, 0.15)
                    table.remove(shots, i)
                    spaceship.updateLifes(-1)
                end
            end
        end
        boss.move(dt)
    end

    if lifes <= 0 then
        if not isBossExploding then
            isBossExploding = true
            explosionCurrentTime = 0
        else
            explosionCurrentTime = explosionCurrentTime + dt
            if explosionCurrentTime < 3 then
                boss.explode()
            else
                if #explosions <= 0 then 
                    isBossDestroyed = true
                end
            end
        end
    end
end

function boss.shoot()
    for i=1, 3 do
        local shot = {
            x = bossAnim.x + (canonPositions[i].x - (spriteBossWidth/2)),
            y = bossAnim.y + (canonPositions[i].y - (spriteBossHeight/2)),
            currentTime = 0,
            duration = bossAnim.shotsSprite.duration,
            quads = bossAnim.shotsSprite.quads,
            spriteSheet = bossAnim.shotsSprite.spriteSheet,
            spriteWidth = spriteShotsWidth,
        }
        table.insert(shots, shot)
    end
end

function boss.draw()
    if lifes > 0 then
        animation.play(bossAnim, bossAnim.x, bossAnim.y, spriteBossWidth/2, spriteBossHeight/2)
    end

    for i, shot in ipairs(shots) do
        animation.play(shot, shot.x, shot.y, spriteShotsWidth/2, spriteShotsHeight/2)
    end
end

function boss.playTheme(play)
    if play then
        bossTheme:play()
    else
        bossTheme:stop()
    end
end

function boss.move(dt)
    if isDestinationReached then
        bossMoveDirection = math.floor(math.random(1, 4))
    end

    if bossMoveDirection == 1 then
        bossAnim.y = bossAnim.y + 50 * dt

        if bossAnim.y >= spriteBossHeight/2 + 50 then
            isDestinationReached = true
        else
            isDestinationReached = false
        end
    elseif bossMoveDirection == 2 then
        bossAnim.y = bossAnim.y - 50 * dt

        if bossAnim.y <= 0 + spriteBossHeight/2 then
            isDestinationReached = true
        else
            isDestinationReached = false
        end
    elseif bossMoveDirection == 3 then
        bossAnim.x = bossAnim.x + 50 * dt

        if bossAnim.x >= ScreenWidth - spriteBossWidth/2 then
            isDestinationReached = true
        else
            isDestinationReached = false
        end
    else
        bossAnim.x = bossAnim.x - 50 * dt

        if bossAnim.x <= 0 + spriteBossWidth/2 then
            isDestinationReached = true
        else
            isDestinationReached = false
        end
    end
end

function boss.lifesCount()
    return lifes
end

function boss.decreaseLifes(dt)
    if lifes > 0 then
        lifes = lifes - 1
    end
end

function boss.explode()
    explosions.add(bossAnim.x + math.random(0, spriteBossWidth/2), bossAnim.y + math.random(0, spriteBossHeight/2), math.random(0.5, 1))
end

function boss.isDestroyed()
    return isBossDestroyed
end

function boss.shots()
    return shots
end

function boss.scoreThreshold()
    return scoreThreshold
end

function boss.scorePoint()
    return scorePoints
end

function boss.isAppearing()
    return isBossAppearing
end

return boss