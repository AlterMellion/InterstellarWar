local boss = {}

require("math")
local animation = require("animation")

local bossAnimSprite
local bossAnim

local spriteShip1Width = 551
local spriteShip1Height = 521

function boss.load()
    bossAnimSprite = animation.new(love.graphics.newImage("pics/BossLevel1.png"), spriteShip1Width, spriteShip1Height, 0.25)
    bossAnim = {
        duration = bossAnimSprite.duration,
        quads = bossAnimSprite.quads,
        spriteSheet = bossAnimSprite.spriteSheet,
        spriteWidth = spriteShip1Width,
        currentTime = 0
    }
end

function boss.draw()
    animation.play(bossAnim, 0, 0, spriteShip1Width/2, spriteShip1Height/2)
end

return boss