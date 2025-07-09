local enemyShip = {}

require("math")
local animation = require("animation")

local enemyPic1
local enemyAnim1

local spriteShip1Width = 60
local spriteShip1Height = 70

local enemyPic2
local enemyAnim2

local spriteShip2Width = 92
local spriteShip2Height = 67

function enemyShip.load()
    enemyPic1 = love.graphics.newImage("pics/enemyShipAnim1.png")
    enemyAnim1 = animation.new(enemyPic1, spriteShip1Width, spriteShip1Height, 0.25)

    enemyPic2 = love.graphics.newImage("pics/enemyShipAnim2.png")
    enemyAnim2 = animation.new(enemyPic2, spriteShip2Width, spriteShip2Height, 0.25)
end

function enemyShip.init()
    math.randomseed(os.time())
    math.random()

    local enemyShip
    if math.floor(math.random(1, 2)) == 1 then
        enemyShip = {
            x = math.random(spriteShip1Width, screenWidth - spriteShip1Width),
            y = 0 - spriteShip1Height,
            duration = enemyAnim1.duration,
            quads = enemyAnim1.quads,
            spriteSheet = enemyAnim1.spriteSheet,
            spriteWidth = spriteShip1Width,
            shipType = 1
        }
    else
        enemyShip = {
            x = math.random(spriteShip2Width, screenWidth - spriteShip2Width),
            y = 0 - spriteShip2Height,
            duration = enemyAnim2.duration,
            quads = enemyAnim2.quads,
            spriteSheet = enemyAnim2.spriteSheet,
            spriteWidth = spriteShip2Width,
            shipType = 1
        }
    end
    enemyShip.speed = math.random(120, 150)
    enemyShip.currentTime = 0
    return enemyShip
end

function enemyShip.draw(enemyShip)
    animation.play(enemyShip, enemyShip.x, enemyShip.y, spriteShip1Width/2, spriteShip1Height/2)
end

function enemyShip.getSpriteWidth(shipType)
    if shipType == 1 then
        return spriteShip1Width
    else
        return spriteShip2Width
    end
end

return enemyShip