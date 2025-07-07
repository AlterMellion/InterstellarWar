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