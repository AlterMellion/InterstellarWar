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
local score = require("score")
local gameover = require("gameover")

function love.load()
    love.window.setTitle("Interstellar War")

    background.load()
    explosions.load()
    playerShots.load()
    spaceship.load()
    enemyShips.load()
    score.load()
    gameover.load()
end

function love.update(dt)
    background.scroll(dt)
    enemyShips.spawn(dt)
    enemyShips.move(dt, spaceship)
    spaceship.move(dt)
    playerShots.move(dt, enemyShips, enemyShips.getPicWidth() / 2)
    explosions.update(dt)
end

function love.draw()
    background.draw()
    enemyShips.draw()
    playerShots.draw()
    explosions.draw()
    spaceship.draw()
    score.draw()

    if spaceship.lifes() == 0 then
        gameover.draw()
    end
end

function love.keypressed(key)
    if(key == "space") then
        if #playerShots < 4 then
            playerShots.shoot(spaceship)
        end
    end
end