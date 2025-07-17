local powerups={}

local animation = require("animation")
local spaceship = require("spaceship")
local helper = require("helper")

local pic
local numberOfSprites = 5
local spriteWidth
local spriteHeight
local sprites
local displayedPowerUps = {}
local sound

function powerups.load()
    pic = love.graphics.newImage("pics/powerups.png")
    spriteWidth = pic:getWidth()/numberOfSprites
    spriteHeight = pic:getHeight()
    sprites = animation.new(pic, spriteWidth, spriteHeight, 0.25)

    sound = love.audio.newSource("audio/powerUp.wav", "static")
end

function powerups.spawn(x, y)
    local spawn = math.floor(math.random(1, 20))
    if spawn % 20 == 0 then
        local index = math.floor(math.random(2, 4))
        local currentPowerUp =  
        {
            index = index,
            x = x,
            y = y
        }
        table.insert(displayedPowerUps, currentPowerUp)
    end
end

function powerups.update(dt)
    for i = #displayedPowerUps, 1, -1 do
        displayedPowerUps[i].y = displayedPowerUps[i].y + 100 * dt

        local distance = helper.distanceBetweenTwoObjects(displayedPowerUps[i].x, displayedPowerUps[i].y, spaceship.x, spaceship.y)
        if distance < spriteWidth then
            sound:play()
            powerups.apply(displayedPowerUps[i].index)
            table.remove(displayedPowerUps, i)
            do break end
        end
    end
end

function powerups.draw()
    for i, powerup in ipairs(displayedPowerUps) do
        if powerup ~= nil then
            love.graphics.draw(sprites.spriteSheet, sprites.quads[powerup.index], powerup.x, powerup.y, 0, 1, 1)
        end
    end
end

function powerups.apply(index)
    if index == 1 then
        -- limited invicibility
    end

    if index == 2 then
        -- lazy loading, to avoid circular dependency
        local playerShots = require("playerShots")
        playerShots.updateOverheatLimit(0.5)
    end

    if index == 3 then
        spaceship.updateLifes(1)
    end

    if index == 4 then
        spaceship.updateArmor(1)
    end

    if index == 5 then
        -- adition weapon firing
    end
end

return powerups