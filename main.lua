-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

screenHeight = love.graphics.getHeight()
screenWidth = love.graphics.getWidth()

local spaceship = require("spaceship")
local playerShots = require("playerShots")
local explosions = require("explosions")
local enemyShips = require("enemyShips")
local background = require("background")

function drawCenter(image, x, y)
    love.graphics.draw(image, x, y, 0, 1, 1,
        image:getWidth()/2,
        image:getHeight()/2
    )
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
    background.load()
    explosions.load()
    playerShots.load()
    spaceship.initSpaceship()
    enemyShips.load()
end

function love.update(dt)
    background.scroll(dt)
    enemyShips.spawnEnemyShip(dt)
    enemyShips.moveEnemyShips(dt)
    spaceship.moveSpaceship(dt)
    playerShots.moveShots(dt, enemyShips, enemyShips.getPicWidth() / 2)
    explosions.updateExplosions(dt)
end

function love.draw()
    background.display()
    drawCenter(spaceship.pic, spaceship.x, spaceship.y)
    enemyShips.displayEnemyships()
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