local explosions = {}

local animation = require("animation")
local explosionAnim
local sound
function explosions.load()
    local explosionSprites = love.graphics.newImage("pics/explosion.png")
    explosionAnim = animation.new(explosionSprites, 192, 192, 1)

    sound = love.audio.newSource("audio/explosion.wav", "static")
end

function explosions.getAnimation()
    return explosionAnim
end

function explosions.playAnim(x, y)
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
        animation.play(explosion, explosion.x, explosion.y, 96, 96)
    end
end

function explosions.playSound()
    sound:stop()
    sound:play()
end

return explosions