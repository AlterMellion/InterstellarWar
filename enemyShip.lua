local enemyShip = {}

require("math")
local animation = require("animation")
    

local enemyPic
local enemyAnim

local spriteWidth = 92
local spriteHeight = 67

function enemyShip.load()
    enemyPic = love.graphics.newImage("pics/enemyShipAnim.png")
    enemyAnim = animation.new(enemyPic, spriteWidth, spriteHeight, 0.25)
end

function enemyShip.init()
    math.randomseed(os.time())
    math.random()

    local enemyShip = {
        speed = math.random(120, 150),
        x = math.random(spriteWidth, screenWidth - spriteWidth),
        y = 0 - spriteHeight,
        currentTime = 0,
        duration = enemyAnim.duration,
        quads = enemyAnim.quads,
        spriteSheet = enemyAnim.spriteSheet,
        spriteWidth = spriteWidth
    }
    return enemyShip
end

function enemyShip.draw(enemyShip)
    animation.play(enemyShip, enemyShip.x, enemyShip.y, spriteWidth/2, spriteHeight/2)
end

return enemyShip