local enemyShip = {}

require("math")
local animation = require("animation")
local config = require("config")

local enemyTypes = {}

function enemyShip.load(level)
    local decodedConfig = config.get()

    for i=1, #decodedConfig[level]["enemies"] do   
        local numberOfSprites = decodedConfig[level]["enemies"][i]["numberOfSprites"]
        local animationSpeed = decodedConfig[level]["enemies"][i]["animationSpeed"]
        local lifes = decodedConfig[level]["enemies"][i]["lifes"]

        local enemyPic = love.graphics.newImage("levelsassets/"..level.."/enemies/"..i.."/enemyShipAnim.png")
        local spriteShipWidth = enemyPic:getWidth()/numberOfSprites
        local spriteShipHeight = enemyPic:getHeight()
        local enemyAnim = animation.new(enemyPic, spriteShipWidth, spriteShipHeight, animationSpeed)

        local enemy = {
            numberOfSprites = numberOfSprites,
            animationSpeed = animationSpeed,
            lifes = lifes,
            pic = enemyPic,
            spriteShipWidth = spriteShipWidth,
            spriteShipHeight = spriteShipHeight,
            enemyAnim = enemyAnim
        }

        table.insert(enemyTypes, enemy)
    end
end

function enemyShip.init()
    math.randomseed(os.time())
    math.random()

    local enemyShip
    local type = math.floor(math.random(1, 2))

    enemyShip = {
        x = math.random(enemyTypes[type].spriteShipWidth, ScreenWidth - enemyTypes[type].spriteShipWidth),
        y = 0 - enemyTypes[type].spriteShipHeight,
        duration = enemyTypes[type].enemyAnim.duration,
        quads = enemyTypes[type].enemyAnim.quads,
        spriteSheet = enemyTypes[type].enemyAnim.spriteSheet,
        spriteWidth = enemyTypes[type].spriteShipWidth,
        spriteHeight = enemyTypes[type].spriteShipHeight,
        shipType = enemyTypes[type].type,
        lifes = enemyTypes[type].lifes
    }

    enemyShip.speed = math.random(120, 150)
    enemyShip.currentTime = 0
    enemyShip.hitTimer = 0
    enemyShip.hitDuration = 0.1
    enemyShip.isHit = false

    return enemyShip
end

function enemyShip.draw(enemyShip)
    animation.play(enemyShip, enemyShip.x, enemyShip.y, enemyShip.spriteWidth/2, enemyShip.spriteHeight/2)
end

return enemyShip