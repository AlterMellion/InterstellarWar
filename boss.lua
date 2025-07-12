local boss = {}

require("math")
local animation = require("animation")

local bossAnimSprite
local bossAnim
local bossTheme

local spriteBossWidth = 415
local spriteBossHeight = 391

function boss.load()
    bossAnimSprite = animation.new(love.graphics.newImage("pics/BossLevel1.png"), spriteBossWidth, spriteBossHeight, 0.25)
    bossAnim = {
        x = ScreenWidth/2,
        y = 0 - spriteBossHeight,
        duration = bossAnimSprite.duration,
        quads = bossAnimSprite.quads,
        spriteSheet = bossAnimSprite.spriteSheet,
        spriteWidth = spriteBossWidth,
        currentTime = 0
    }
    bossTheme = love.audio.newSource("audio/ufo-battle-355493.mp3", "static")
end

function boss.update(dt)
    print(bossAnim.x.." - "..bossAnim.y)
    bossAnim.currentTime = bossAnim.currentTime + dt
    if bossAnim.currentTime >= bossAnim.duration then
        bossAnim.currentTime = bossAnim.currentTime - bossAnim.duration
    end

    if bossAnim.y < spriteBossHeight/2 then
        bossAnim.y = bossAnim.y + 100 * dt
    else
        bossAnim.y = bossAnim.y + math.random(-1, 1) * dt 
        bossAnim.x = bossAnim.x + math.random(-1, 1) * dt
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
return boss