-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

love.window.setMode(600, 800)

ScreenHeight = love.graphics.getHeight()
ScreenWidth = love.graphics.getWidth()

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
local endScreen = require("endScreen")
local boss = require("boss")

IsGameOver = false
local sleepTimer = 0
local isGameStarted = false
local isGameComplete = false
local bossLevel1Threshold = 10
local isBossLoaded = false
local bossInstance

function ResetGame()
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
    if isGameComplete then
        if not endScreen.isLoaded() then
            endScreen.load()
            boss.playTheme(false)
            endScreen.startMusic()
        end
        return
    end

    if isGameStarted then
        background.scroll(dt)

        if not isBossLoaded then
            if score.getValue() < bossLevel1Threshold then
                enemyShips.spawn(dt)
            elseif #enemyShips.getTable() == 0 then
                bossInstance = boss.load()
                background.stopMusic()
                boss.playTheme(true)
                isBossLoaded = true
            end
        else
            if not boss.isDestroyed() then
                boss.update(dt)
            else
                bossInstance = nil
                isGameComplete = true
            end
        end
        
        enemyShips.move(dt, spaceship)
        spaceship.move(dt)
        playerShots.update(dt, enemyShips.getTable(), bossInstance)
        explosions.update(dt)

        if IsGameOver then
            sleepTimer = sleepTimer + dt
            if sleepTimer > 1 then
                continue.updateCountdown()
                sleepTimer = 0

                if continue.countdownNumber() < 1 then
                    isGameStarted = false
                    IsGameOver = false
                    background.stopGameOverTheme()
                    startScreen.startMusic()
                end
            end
        end
    else
        startScreen.update(dt)
    end
end

function love.draw()
    if isGameComplete then
        if endScreen.isLoaded() then
        endScreen.draw()
        end
        ResetGame()
        return
    end

    if isGameStarted then
        background.draw()
        
        if #enemyShips.getTable() > 0 then
            enemyShips.draw()
        elseif isBossLoaded then
            if not boss.isDestroyed() then
                boss.draw()
            end
        end

        if #playerShots > 0 then
            playerShots.draw()
        end

        if #explosions > 0 then
            explosions.draw()
        end
        spaceship.draw()
        score.draw()

        if spaceship.lifes() == 0 or IsGameOver then
            IsGameOver = true
            gameover.draw()
            continue.draw()
            background.stopMusic()
            background.startGameOverTheme()
        end
    else
        startScreen.draw()
        ResetGame()
    end
end

function love.keypressed(key)
    if isGameStarted then
        if key == "space" then
            playerShots.shoot(spaceship)
        end

        if(key == "return") then
            if IsGameOver then
                ResetGame()
                IsGameOver = false
                background.stopGameOverTheme()
                background.startMusic()
            end
            if isGameComplete then
                isGameStarted = false
                isGameComplete = false
                endScreen.stopMusic()
                startScreen.startMusic()
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