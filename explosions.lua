local explosions = {}

local animation = require("animation")
local explosionAnim
local sound

local spriteWidth = 192
local spriteHeight = 192

function explosions.load()
    local explosionSprites = love.graphics.newImage("pics/explosion.png")
    explosionAnim = animation.new(explosionSprites, spriteWidth, spriteHeight, 1)

    sound = love.audio.newSource("audio/explosion.wav", "static")
end

function explosions.getAnimation()
    return explosionAnim
end

function explosions.add(x, y)
    local explosion = {
        x = x,
        y = y,
        currentTime = 0,
        duration = explosionAnim.duration,
        quads = explosionAnim.quads,
        spriteSheet = explosionAnim.spriteSheet
    }
    table.insert(explosions, explosion)
    explosions.playSound()
end

function explosions.update(dt)
    for i=#explosions, 1, -1 do
        explosions[i].currentTime = explosions[i].currentTime + dt
        if explosions[i].currentTime >= explosions[i].duration then
            table.remove(explosions, i)
        end
    end
end

function explosions.draw()
    for i, explosion in ipairs(explosions) do
        animation.play(explosion, explosion.x, explosion.y, spriteWidth/2, spriteHeight/2)
    end
end

function explosions.playSound()
    sound:stop()
    sound:play()
end

return explosions