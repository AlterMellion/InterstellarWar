local explosions = {}
local animation = require("animation")
local explosionAnim

function explosions.load()
    local explosionSprites = love.graphics.newImage("pics/explosion.png")
    explosionAnim = animation.new(explosionSprites, 192, 192, 1)
end

function explosions.getAnimation()
    return explosionAnim
end

function explosions.updateExplosions(dt)
    for i=#explosions, 1, -1 do
        explosions[i].currentTime = explosions[i].currentTime + dt
        if explosions[i].currentTime >= explosions[i].duration then
            table.remove(explosions, i)
        end
    end
end

function explosions.drawExplosions()
    for i, explosion in ipairs(explosions) do
        animation.play(explosion, explosion.x, explosion.y, 96, 96)
    end
end

return explosions