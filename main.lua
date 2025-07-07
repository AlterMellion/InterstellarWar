-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local background
local scrollingSpeed = 25
local backGroundy = 0

screenHeight = love.graphics.getHeight()
screenWidth = love.graphics.getWidth()

local spaceship = require("spaceship")
local playerShots = require("playerShots")
local explosions = require("explosions")

local enemyShips = {}
local maxEnemiesOnScreen = 3
local enemyPic
local enemyTimer = 0
local enemyFrequency = 2

function drawCenter(image, x, y)
    love.graphics.draw(image, x, y, 0, 1, 1,
        image:getWidth()/2,
        image:getHeight()/2
    )
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

function distanceBetweenTwoObjects(x1, y1, x2, y2)
    local deltaX = x2 - x1
    local deltaY = y2 - y1

    local deltaXSquare = deltaX ^ 2
    local deltaYSquare = deltaY ^ 2

    local squareSum = deltaXSquare + deltaYSquare

    local distance = squareSum ^ 0.5
    return distance
end

function love.load()
    love.window.setTitle("Interstellar War")
    background = love.graphics.newImage("pics/spaceBackground.jpg")
    enemyPic = love.graphics.newImage("pics/enemyShip.png")
    
    explosions.load()
    playerShots.load()
    spaceship.initSpaceship()
    enemyShips = {}
end

function love.update(dt)
    scrollBackground(dt)

    spawnEnemyShip(dt)
    moveEnemyShips(dt)

    spaceship.moveSpaceship(dt)

    playerShots.moveShots(dt, enemyShips, enemyPic:getWidth() / 2)

    explosions.updateExplosions(dt)
end

function love.draw()
    love.graphics.draw(background, 0, backGroundy)
    love.graphics.draw(background, 0, backGroundy - background:getHeight())

    drawCenter(spaceship.pic, spaceship.x, spaceship.y)
    
    displayEnemyships()
    playerShots.displayPlayerShots()

    explosions.drawExplosions()
end

function love.keypressed(key)
    if(key == "space") then
        if #playerShots < 4 then
            playerShots.fireShot(spaceship)
        end
    end
end