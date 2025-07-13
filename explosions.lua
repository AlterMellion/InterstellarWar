local explosions = {}

local animation = require("animation")
local explosionAnim
local sound

local numberOfSprites = 10
local spriteWidth
local spriteHeight

function explosions.load()
    local explosionSprites = love.graphics.newImage("pics/explosion.png")
    spriteWidth = explosionSprites:getWidth()/numberOfSprites
    spriteHeight = explosionSprites:getHeight()
    explosionAnim = animation.new(explosionSprites, spriteWidth, spriteHeight, 1)

    sound = love.audio.newSource("audio/explosion.wav", "static")
end

function explosions.getAnimation()
    return explosionAnim
end

function explosions.add(x, y, scale)
    local explosion = {
        x = x,
        y = y,
        currentTime = 0,
        duration = explosionAnim.duration,
        quads = explosionAnim.quads,
        spriteSheet = explosionAnim.spriteSheet,
        scale = scale,
        rotation = math.random(0, 360),
        soundPlayed = false

    }
    table.insert(explosions, explosion)
end

function explosions.update(dt)
    for i=#explosions, 1, -1 do
        explosions[i].currentTime = explosions[i].currentTime + dt
        if explosions[i].currentTime >= explosions[i].duration then
            table.remove(explosions, i)
        elseif not explosions[i].soundPlayed then
            sound:play()
            explosions[i].soundPlayed = true
        end
    end
end

function explosions.draw()
    for i, explosion in ipairs(explosions) do
        animation.play(explosion, explosion.x, explosion.y, explosion.scale * spriteWidth/2, explosion.scale * spriteHeight/2, explosion.scale, explosion.rotation)
    end
end

return explosions