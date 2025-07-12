local boss = {}

require("math")
local animation = require("animation")
local explosions = require("explosions")
local spaceship = require("spaceship")
local helper = require("helper")

local bossAnimSprite
local bossAnim
local bossTheme

local spriteBossWidth = 412
local spriteBossHeight = 389
local bossMoveDirection
local isDestinationReached = false
local isBossDestroyed = false
local isBossExploding = true
local explosionCurrentTime = 0

local lifes = 5
local isHit = false
local hitDuration = 0.1
local hurtSound


local spriteShotsWidth = 28
local spriteShotsHeight = 66
local shots = {}
local lastShots = 0
local coolDown = 1
local canonPositions = {
    {x = 114, y = 313}, --left canon
    {x = 206, y = 388}, -- middle canon 
    {x = 295, y = 313}  -- right canon
}

function boss.load()
    local bossShotsSprite = animation.new(love.graphics.newImage("pics/bossShotAnim.png"), spriteShotsWidth, spriteShotsHeight, 0.25)

    bossAnimSprite = animation.new(love.graphics.newImage("pics/BossLevel1.png"), spriteBossWidth, spriteBossHeight, 0.25)
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
    bossTheme = love.audio.newSource("audio/ufo-battle-355493.mp3", "static")

    hurtSound = love.audio.newSource("audio/hitHurt.wav", "static")
    
    return bossAnim
end

function boss.update(dt)
    bossAnim.currentTime = bossAnim.currentTime + dt
    if bossAnim.currentTime >= bossAnim.duration then
        bossAnim.currentTime = bossAnim.currentTime - bossAnim.duration
    end

    if bossAnim.y < spriteBossHeight/2 then
        bossAnim.y = bossAnim.y + 100 * dt
    else
        lastShots = lastShots + dt
        if lastShots > coolDown and lifes > 0 then
            boss.shoot()
            lastShots = 0
            coolDown = math.random(1, 2.5)
        end

        for i=#shots, 1, -1 do
            shots[i].currentTime = shots[i].currentTime + dt
            if shots[i].currentTime >= shots[i].duration then
                shots[i].currentTime = shots[i].currentTime - shots[i].duration
            end

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

function boss.playHurtSound()
    hurtSound:play()
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
return boss