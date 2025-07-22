local spaceship = {}

local explosions = require("explosions")
local animation = require("animation")
local audio = require("audio")

local baselifes = 3
local lifes
local hitTimer = 0
local isHit = false
local hitDuration = 2

local speed = 200

local spaceshipPic
local picWidth
local picHeight

local spaceshipSprite
local numberOfSprites = 3
local spriteWidth
local spriteHeight
local spaceshipAnim


local armor = 0
local armorBreakSound
local shieldSprite
local numberOfShieldSprites = 5
local shieldSpriteWidth
local shieldSpriteHeight
local shieldSpriteAnim

function spaceship.load()
    lifes = baselifes
    spaceshipPic = love.graphics.newImage("pics/spaceship.png")
    picWidth = spaceshipPic:getWidth()
    picHeight = spaceshipPic:getHeight()

    spaceshipSprite = love.graphics.newImage("pics/spaceshipAnim.png")
    spriteWidth = spaceshipSprite:getWidth()/numberOfSprites
    spriteHeight = spaceshipSprite:getHeight()
    spaceshipAnim = animation.new(spaceshipSprite, spriteWidth, spriteHeight, 0.25)
    spaceshipAnim.currentTime = 0

    spaceship.x = ScreenWidth/2
    spaceship.y = ScreenHeight + spriteHeight
    spaceship.speed = speed

    shieldSprite = love.graphics.newImage("pics/magneticShield.png")
    shieldSpriteWidth = shieldSprite:getWidth()/numberOfShieldSprites
    shieldSpriteHeight = shieldSprite:getHeight()
    shieldSpriteAnim = animation.new(shieldSprite, shieldSpriteWidth, shieldSpriteHeight, 0.5)
    shieldSpriteAnim.currentTime = 0
    armorBreakSound = love.audio.newSource("audio/armorBreak.wav", "static")
end

function spaceship.draw()
    -- Blink when being hit
    if lifes > 0 then
        if not isHit or armor > 0 or (isHit and math.floor(love.timer.getTime() * 100) % 2 == 0) then
            animation.play(spaceshipAnim, spaceship.x, spaceship.y, spriteWidth/2, spriteHeight/2)
        end
    end

    -- Display remaining lifes in the top right corner of the screen
    for i=1, lifes do
        local scale = 0.40
        local x = ScreenWidth - (picWidth * i * scale)
        love.graphics.draw(spaceshipPic, x, picHeight * scale, 0, scale, scale,
            picWidth/2,
            picHeight/2
        )
    end

    -- Display armor
    if armor > 0 then
        animation.play(shieldSpriteAnim, spaceship.x, spaceship.y, shieldSpriteWidth/2, shieldSpriteHeight/2, 1.4)
    end
end

function spaceship.update(dt)
    if spaceship.y > (ScreenHeight - spriteHeight/2) then
        spaceship.y = spaceship.y - 50 * dt
    else
        animation.update(spaceshipAnim, dt)
        animation.update(shieldSpriteAnim, dt)

        -- Recovery time during which the player can't be damaged again
        hitTimer = hitTimer + dt
        if hitTimer > hitDuration then
            isHit = false
        end

        spaceship.move(dt)
    end
end

function spaceship.move(dt)  
    if love.keyboard.isDown("left") then
        spaceship.x = spaceship.x - spaceship.speed * dt
        
        if spaceship.x - spriteWidth/2 < 0 then
            spaceship.x = spriteWidth/2
        end
    end

    if love.keyboard.isDown("right") then
        spaceship.x = spaceship.x + spaceship.speed * dt

        if (spaceship.x + spriteWidth/2) >= ScreenWidth then
            spaceship.x = ScreenWidth - spriteWidth/2
        end
    end

    if love.keyboard.isDown("up") then
        spaceship.y = spaceship.y - spaceship.speed * dt

        if spaceship.y - spriteHeight/2 <= 0 then
            spaceship.y = spriteHeight/2
        end
    end

    if love.keyboard.isDown("down") then
        spaceship.y = spaceship.y + spaceship.speed * dt

        if spaceship.y + spriteHeight /2 > ScreenHeight then
            spaceship.y = ScreenHeight - spriteHeight/2
        end
    end
end

function spaceship.lifes()
    return lifes
end

function spaceship.updateLifes(value)
    if hitTimer > hitDuration then
        if value == -1 and armor > 0 then
            spaceship.updateArmor(-1)
            isHit = true
            hitTimer = 0
            armorBreakSound:play()
            return
        end
        
        lifes = lifes + value
        if lifes == 0 then
            explosions.add(spaceship.x, spaceship.y, 1)
        else
            if value == -1 then
                audio.playHurtSound()
                isHit = true
                hitTimer = 0
            end
        end
    end
end

function spaceship.updateArmor(value)
    if armor == 0 and value == -1 then
        return armor
    end

    armor = armor + value
    return armor
end

function spaceship.getPosition()
    local positions = {
        x = spaceship.x,
        y = spaceship.y,
        width = spriteWidth
    }
    return positions
end
return spaceship