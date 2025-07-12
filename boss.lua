local boss = {}

require("math")
local animation = require("animation")
local explosions = require("explosions")

local bossAnimSprite
local bossAnim
local bossTheme

local spriteBossWidth = 412
local spriteBossHeight = 389
local bossMoveDirection
local isDestinationReached = true
local isBossDestroyed = false

local lifes = 50
local isHit = false
local hitDuration = 0.1
local hurtSound

function boss.load()
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
        explodingDuration = 3
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
        boss.move(dt)
    end
end

function boss.draw()
    animation.play(bossAnim, bossAnim.x, bossAnim.y, spriteBossWidth/2, spriteBossHeight/2)
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

function boss.decreaseLifes(dt)
    if lifes > 0 then
        lifes = lifes - 1
    else
        if not isBossDestroyed then
            bossAnim.currentTime = bossAnim.currentTime + dt
            if bossAnim.currentTime <= bossAnim.explodingDuration then            
                for i=1, 10 do
                    explosions.add(bossAnim.x + math.random(0, spriteBossWidth), bossAnim.y + math.random(0, spriteBossHeight), math.random(0.5, 1))
                end
                boss.decreaseLifes(dt)
            else
                isBossDestroyed = true
            end
        end
    end
end

function boss.isDestroyed()
    return isBossDestroyed
end

return boss