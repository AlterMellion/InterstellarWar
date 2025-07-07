local spaceship = {}

local helper = require("helper")
local explosions = require("explosions")

local lifes = 3
local hitTimer = 0

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
        helper.drawCenter(spaceship.pic, spaceship.x, spaceship.y)
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
    if hitTimer > 2 then
        lifes = lifes + value
        hitTimer = 0

        if lifes < 1 then
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
            end
        end
    end
end

return spaceship