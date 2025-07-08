local spaceship = {}

local helper = require("helper")
local explosions = require("explosions")

local lifes = 3
local hitTimer = 0
local isHit = false
local hitDuration= 2

local explosionAnim
local hurtSound

local picWidth
local picHeight

function spaceship.load()
    spaceship.pic = love.graphics.newImage("pics/spaceship.png")
    picWidth = spaceship.pic:getWidth()
    picHeight = spaceship.pic:getHeight()

    spaceship.speed = 200
    spaceship.x = screenWidth/2
    spaceship.y = screenHeight - picHeight/2

    explosionAnim = explosions.getAnimation()

    hurtSound = love.audio.newSource("audio/hitHurt.wav", "static")
end

function spaceship.draw()
    if lifes > 0 then
        if not isHit or (isHit and math.floor(love.timer.getTime() * 100) % 2 == 0) then
            helper.drawCenter(spaceship.pic, spaceship.x, spaceship.y)
        end
    end

    for i=1, lifes do
        local scale = 0.40
        local x = screenWidth - (picWidth * i * scale)
        love.graphics.draw(spaceship.pic, x, picHeight * scale, 0, scale, scale,
            picWidth/2,
            picHeight/2
        )
    end
end

function spaceship.move(dt)
    hitTimer = hitTimer + dt
    if hitTimer > hitDuration then
        isHit = false
    end

    if love.keyboard.isDown("left") then
        spaceship.x = spaceship.x - spaceship.speed * dt
        
        if spaceship.x - picWidth/2 < 0 then
            spaceship.x = picWidth/2
        end
    end

    if love.keyboard.isDown("right") then
        spaceship.x = spaceship.x + spaceship.speed * dt

        if (spaceship.x + picWidth/2) >= screenWidth then
            spaceship.x = screenWidth - picWidth/2
        end
    end

    if love.keyboard.isDown("up") then
        spaceship.y = spaceship.y - spaceship.speed * dt

        if spaceship.y - picHeight/2 <= 0 then
            spaceship.y = picHeight/2
        end
    end

    if love.keyboard.isDown("down") then
        spaceship.y = spaceship.y + spaceship.speed * dt

        if spaceship.y + picHeight /2 > screenHeight then
            spaceship.y = screenHeight - picHeight/2
        end
    end
end

function spaceship.lifes()
    return lifes
end

function spaceship.updateLifes(value)
    if hitTimer > hitDuration then
        lifes = lifes + value
        
        if lifes == 0 then
            explosions.add(spaceship.x, spaceship.y)
        else
            if value == -1 then
                hurtSound:play()
                isHit = true
                hitTimer = 0
            end
        end
    end
end

return spaceship