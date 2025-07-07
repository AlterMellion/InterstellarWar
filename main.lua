-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local background
local scrollingSpeed = 25
local backGroundy = 0

local screenHeight = love.graphics.getHeight()
local screenWidth = love.graphics.getWidth()

local spaceship = {}

local enemyShips = {}
local maxEnemiesOnScreen = 3
local enemyPic
local enemyTimer = 0
local enemyFrequency = 2

local playerShots = {}
local basicShotPic
local shotSpeed = 200

local explosionAnim = {}
local explosions = {}

function initSpaceship()
    spaceship.speed = 200
    spaceship.x = screenWidth / 2
    spaceship.y = screenHeight - spaceship.pic:getHeight() / 2
end

function drawCenter(image, x, y)
    love.graphics.draw(image, x, y, 0, 1, 1,
        image:getWidth()/2,
        image:getHeight()/2
    )
end

function moveSpaceship(dt)
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

function initEnemyShip()
    local enemyShip = {}
    enemyShip.speed = math.random(120, 150)
    enemyShip.pic = enemyPic
    enemyShip.x = math.random(enemyShip.pic:getWidth(), screenWidth - enemyShip.pic:getWidth())
    enemyShip.y = 0 - enemyShip.pic:getHeight()
    return enemyShip
end

function spawnEnemyShip(dt)
    enemyTimer = enemyTimer + dt
    if #enemyShips < maxEnemiesOnScreen and enemyTimer > enemyFrequency then
        table.insert(enemyShips, initEnemyShip())
        enemyTimer = 0
        enemyFrequency = math.random(1, 3)
    end
end

function moveEnemyShips(dt)
    for i=#enemyShips, 1, -1 do
        enemyShips[i].y = enemyShips[i].y + enemyShips[i].speed * dt

        if enemyShips[i].y > screenHeight + enemyPic:getHeight() then
            table.remove(enemyShips, i)
        end
    end
end

function displayEnemyships()
    for i, enemyShip in ipairs(enemyShips) do
        drawCenter(enemyShip.pic, enemyShip.x, enemyShip.y)
    end
end

function scrollBackground(dt)
    backGroundy = backGroundy + scrollingSpeed * dt
    if backGroundy >= background:getHeight() then
        backGroundy = 0
    end
end

function displayPlayerShots()
    for i, shot in ipairs(playerShots) do
        drawCenter(basicShotPic, shot.x, shot.y)
    end
end

function fireShot()
    local shot = {
        x = spaceship.x,
        y = spaceship.y - basicShotPic:getHeight()
    }
    table.insert(playerShots, shot)
end

function moveShots(dt)
    for i=#playerShots, 1, -1 do
        local currentShot = playerShots[i] 
        currentShot.y = currentShot.y - shotSpeed * dt

        if currentShot.y < 0 - basicShotPic:getHeight() then
            table.remove(playerShots, i)
            do break end
        else
            for j=#enemyShips, 1, -1 do
                local currentEnemy = enemyShips[j]
                local distance = distanceBetweenTwoObjects(currentEnemy.x, currentEnemy.y, currentShot.x, currentShot.y)
                
                if distance < enemyPic:getWidth() / 2 then
                    local explosion = {
                        x = currentEnemy.x,
                        y = currentEnemy.y,
                        currentTime = 0,
                        duration = explosionAnim.duration,
                        quads = explosionAnim.quads,
                        spriteSheet = explosionAnim.spriteSheet
                    }
                    table.insert(explosions, explosion)
                    table.remove(enemyShips, j)
                    table.remove(playerShots, i)
                    break
                end
            end
        end
    end
end

function distanceBetweenTwoObjects(x1, y1, x2, y2)
    local deltaX = x2 - x1
    local deltaY = y2 - y1

    local deltaXSquare = deltaX ^ 2
    local deltaYSquare = deltaY ^ 2

    local squareSum = deltaXSquare + deltaYSquare

    local distance = squareSum ^ 0.5
    return distance
end

function updateExplosions(dt)
    for i=#explosions, 1, -1 do
        explosions[i].currentTime = explosions[i].currentTime + dt
        if explosions[i].currentTime >= explosions[i].duration then
            table.remove(explosions, i)
        end
    end
end

function drawExplosions()
    for i, explosion in ipairs(explosions) do
        playAnimation(explosion, explosion.x, explosion.y, 96, 96)
    end
end

function playAnimation(animation, x, y, ox, oy)
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], x, y, 0, 1, 1, ox, oy)
end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0
    return animation
end

function love.load()
    love.window.setTitle("Interstellar War")
    background = love.graphics.newImage("pics/spaceBackground.jpg")

    spaceship.pic = love.graphics.newImage("pics/spaceship.png")
    enemyPic = love.graphics.newImage("pics/enemyShip.png")
    basicShotPic = love.graphics.newImage("pics/basicShot.png")
    
    initSpaceship()
    enemyShips = {}
    playerShots = {}
    
    local explosionSprites = love.graphics.newImage("pics/explosion.png")
    explosionAnim = newAnimation(explosionSprites, 192, 192, 1)
    explosions = {}
end

function love.update(dt)
    scrollBackground(dt)

    spawnEnemyShip(dt)
    moveEnemyShips(dt)

    moveSpaceship(dt)

    moveShots(dt)

    updateExplosions(dt)
end

function love.draw()
    love.graphics.draw(background, 0, backGroundy)
    love.graphics.draw(background, 0, backGroundy - background:getHeight())

    drawCenter(spaceship.pic, spaceship.x, spaceship.y)
    
    displayEnemyships()
    displayPlayerShots()

    drawExplosions()
end

function love.keypressed(key)
    if(key == "space") then
        if #playerShots < 4 then
            fireShot()
        end
    end
end