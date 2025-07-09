-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

love.window.setMode(600, 800)

screenHeight = love.graphics.getHeight()
screenWidth = love.graphics.getWidth()

local spaceship = require("spaceship")
local playerShots = require("playerShots")
local explosions = require("explosions")
local enemyShip = require("enemyShip")
local enemyShips = require("enemyShips")
local background = require("background")
local score = require("score")
local gameover = require("gameover")
local continue = require("continue")
local startScreen = require("startScreen")

local isGameOver = false
local sleepTimer = 0
local isGameStarted = false

function resetGame()
    continue.resetCountdown()
    enemyShips.reset()
    spaceship.load()
    score.load()
end

function love.load()
    love.window.setTitle("Interstellar War")

    background.load()
    explosions.load()
    playerShots.load()
    spaceship.load()
    enemyShip.load()
    enemyShips.load()
    score.load()
    gameover.load()
    continue.load()
    startScreen.load()
end

function love.update(dt)
    if isGameStarted then
        background.scroll(dt)
        enemyShips.spawn(dt)
        enemyShips.move(dt, spaceship)
        spaceship.move(dt)
        playerShots.update(dt, enemyShips.getTable())
        explosions.update(dt)

        if isGameOver then
            sleepTimer = sleepTimer + dt
            if sleepTimer > 1 then
                continue.updateCountdown()
                sleepTimer = 0

                if continue.countdownNumber() < 1 then
                    isGameStarted = false
                    isGameOver = false
                    background.stopGameOverTheme()
                    startScreen.startMusic()
                end
            end
        end
    end
end

function love.draw()
    if isGameStarted then
        background.draw()
        enemyShips.draw()
        playerShots.draw()
        explosions.draw()
        spaceship.draw()
        score.draw()

        if spaceship.lifes() == 0 or isGameOver then
            isGameOver = true
            gameover.draw()
            continue.draw()
            background.stopMusic()
            background.startGameOverTheme()
        end
    else
        startScreen.draw()
        resetGame()
    end
end

function love.keypressed(key)
    if isGameStarted then
        if key == "space" then
            playerShots.shoot(spaceship)
        end

        if isGameOver then
            if(key == "return") then
                resetGame()
                isGameOver = false
                background.stopGameOverTheme()
                background.startMusic()
            end
        end
    else
        if(key == "return") then
            isGameStarted = true
            startScreen.stopMusic()
            background.startMusic()
        end
    end
end