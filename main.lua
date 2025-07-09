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
local enemyShips = require("enemyShips")
local background = require("background")
local score = require("score")
local gameover = require("gameover")
local continue = require("continue")
local startScreen = require("startScreen")

local isGameOver = false
local sleepTimer = 0
local gameStarted = false

function love.load()
    love.window.setTitle("Interstellar War")

    background.load()
    explosions.load()
    playerShots.load()
    spaceship.load()
    enemyShips.load()
    score.load()
    gameover.load()
    continue.load()
    startScreen.load()
end

function love.update(dt)
    if gameStarted then
        background.scroll(dt)
        enemyShips.spawn(dt)
        enemyShips.move(dt, spaceship)
        spaceship.move(dt)
        playerShots.move(dt, enemyShips.getTable())
        explosions.update(dt)

        if isGameOver then
            sleepTimer = sleepTimer + dt
            if sleepTimer > 1 then
                continue.updateCountdown()
                sleepTimer = 0

                if continue.countdownNumber() < 1 then
                    gameStarted = false
                    isGameOver = false
                    background.stopGameOverTheme()
                    startScreen.startMusic()
                end
            end
        end
    end
end

function love.draw()
    if gameStarted then
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
        continue.resetCountdown()
        enemyShips.reset()
        spaceship.load()
        score.load()
        startScreen.draw()
    end
end

function love.keypressed(key)
    if gameStarted then
        if key == "space" then
            if #playerShots < 4 then
                playerShots.shoot(spaceship)
            end
        end
    else
        if(key == "return") then
            print("enter: start game")
            gameStarted = true
            startScreen.stopMusic()
            background.startMusic()
        end
    end
end