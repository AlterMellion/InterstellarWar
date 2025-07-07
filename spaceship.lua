local spaceship = {}

function spaceship.initSpaceship()
    spaceship.pic = love.graphics.newImage("pics/spaceship.png")
    spaceship.speed = 200
    spaceship.x = screenWidth / 2
    spaceship.y = screenHeight - spaceship.pic:getHeight() / 2
end


function spaceship.moveSpaceship(dt)
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

return spaceship