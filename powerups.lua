local powerups={}

local animation = require("animation")

local pic
local numberOfSprites = 5
local spriteWidth
local spriteHeight
local sprites
local displayedPowerUps = {}

function powerups.load()
    pic = love.graphics.newImage("pics/powerups.png")
    spriteWidth = pic:getWidth()/numberOfSprites
    spriteHeight = pic:getHeight()
    sprites = animation.new(pic, spriteWidth, spriteHeight, 0.25)
end

function powerups.spawn(x, y)
    local spawn = math.floor(math.random(1, 10))
    if spawn % 10 == 0 then
        local index = math.floor(math.random(1,5))
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
    end
end

function powerups.draw()
    for i, powerup in ipairs(displayedPowerUps) do
        if powerup ~= nil then
            love.graphics.draw(sprites.spriteSheet, sprites.quads[powerup.index], powerup.x, powerup.y, 0, 1, 1)
        end
    end
end

return powerups