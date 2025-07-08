local spaceship = {}

local helper = require("helper")
local explosions = require("explosions")

local lifes = 3
local hitTimer = 0
local isHit = false
local hitDuration= 2

local explosionAnim
local sound

function spaceship.load()
    spaceship.pic = love.graphics.newImage("pics/spaceship.png")
    spaceship.speed = 200
    spaceship.x = screenWidth / 2
    spaceship.y = screenHeight - spaceship.pic:getHeight() / 2

    explosionAnim = explosions.getAnimation()

    sound = love.audio.newSource("audio/hitHurt.wav", "static")
end

function spaceship.draw()
    if lifes > 0 then
        if not isHit or (isHit and math.floor(love.timer.getTime() * 100) % 2 == 0) then
            helper.drawCenter(spaceship.pic, spaceship.x, spaceship.y)
        end
    end

    for i=1, lifes do
        local scale = 0.40
        local x = screenWidth - (spaceship.pic:getWidth() * i * scale)
        love.graphics.draw(spaceship.pic, x, spaceship.pic:getHeight() * scale, 0, scale, scale,
            spaceship.pic:getWidth()/2,
            spaceship.pic:getHeight()/2
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
        
        if spaceship.x < 0 then
            spaceship.x = 0
        end
    end

    if love.keyboard.isDown("right") then
        spaceship.x = spaceship.x + spaceship.speed * dt

        if (spaceship.x + spaceship.pic:getWidth()) >= screenWidth then
            spaceship.x = screenWidth - spaceship.pic:getWidth()
        end
    end

    if love.keyboard.isDown("up") then
        spaceship.y = spaceship.y - spaceship.speed * dt

        if spaceship.y <= 0 then
            spaceship.y = 0
        end
    end

    if love.keyboard.isDown("down") then
        spaceship.y = spaceship.y + spaceship.speed * dt

        if spaceship.y + spaceship.pic:getHeight() > screenHeight then
            spaceship.y = screenHeight - spaceship.pic:getHeight()
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
            local explosion = {
                x = spaceship.x,
                y = spaceship.y,
                currentTime = 0,
                duration = explosionAnim.duration,
                quads = explosionAnim.quads,
                spriteSheet = explosionAnim.spriteSheet
            }
            table.insert(explosions, explosion)
            explosions.playSound()
        else
            if value == -1 then
                sound:play()
                isHit = true
                hitTimer = 0
            end
        end
    end
end

return spaceship