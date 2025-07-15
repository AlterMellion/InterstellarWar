-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

love.window.setMode(600, 800)

ScreenHeight = love.graphics.getHeight()
ScreenWidth = love.graphics.getWidth()

local config = require("config")
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
local audio = require("audio")

IsGameOver = false
local GameOverLoaded = false
local sleepTimer = 0
local isGameStarted = false
local isGameComplete = false
local isBossLoaded = false
local bossInstance

local level = 1

function ResetGame()
    continue.resetCountdown()
    enemyShips.reset()
    spaceship.load()
    score.load()
end

function love.load()
    love.window.setTitle("Interstellar War")

    config.load()
    startScreen.load()
    audio.load()
    background.load("level"..level)
    explosions.load()
    playerShots.load()
    spaceship.load()
    enemyShip.load("level"..level)
    enemyShips.load()
    score.load()
    boss.loadConfig("level"..level)
end

function love.update(dt)
    if isGameComplete then
        if not endScreen.isLoaded() then
            endScreen.load()
            boss.playTheme(false)
            endScreen.startMusic()
        else
            endScreen.update(dt)
        end
        return
    end

    if isGameStarted then
        background.scroll(dt)

        if not isBossLoaded then
            if score.getValue() < boss.scoreThreshold() then
                enemyShips.spawn(dt)
            elseif #enemyShips.getTable() == 0 and #explosions <= 0 then
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
        
        enemyShips.move(dt)
        spaceship.update(dt)
        playerShots.update(dt, enemyShips.getTable(), bossInstance)
        explosions.update(dt)

        if IsGameOver then
            if not GameOverLoaded then
                gameover.load()  
                continue.load()
                GameOverLoaded = true
            end
            sleepTimer = sleepTimer + dt
            if sleepTimer > 1 then
                continue.updateCountdown()
                sleepTimer = 0

                if continue.countdownNumber() < 1 then
                    isGameStarted = false
                    IsGameOver = false
                    background.stopGameOverTheme()
                    if isBossLoaded then
                        boss.playTheme(true)
                    else
                        startScreen.startMusic()
                    end
                end
            end
        end
    else
        startScreen.update(dt)
    end
end

function love.draw()
    if isGameStarted then
        if isGameComplete then
            if endScreen.isLoaded() then
                endScreen.draw()
                ResetGame()
                if endScreen.creditsEnd() then
                    isGameStarted = false
                    isGameComplete = false
                    endScreen.stopMusic()
                    startScreen.startMusic()
                end
                return
            end
        end

        background.draw()
        
        if #enemyShips.getTable() > 0 then
            enemyShips.draw()
        elseif isBossLoaded then
            if boss.lifesCount() > 0 or #boss.shots() > 0 then
                boss.draw()
            end
        end

        playerShots.draw()

        if #explosions > 0 then
            explosions.draw()
        end
        print(spaceship.lifes())
        spaceship.draw()
        score.draw()

        if spaceship.lifes() == 0 or IsGameOver then
            IsGameOver = true
            if GameOverLoaded then
                gameover.draw()
                continue.draw()
                if isBossLoaded then
                    boss.playTheme(false)
                else
                    background.stopMusic()
                end
                background.startGameOverTheme()     
            end
        end
    else
        startScreen.draw()
        ResetGame()
    end
end

function love.keypressed(key)
    if isGameStarted then
        if key == "space" then
            if not isGameComplete then
                playerShots.shoot(spaceship)
            end
        end

        if(key == "return") then
            if IsGameOver then
                ResetGame()
                IsGameOver = false
                background.stopGameOverTheme()
                if isBossLoaded then
                    boss.playTheme(true)
                else
                    background.startMusic()
                end
            end
            if isGameComplete then
                isGameStarted = false
                isGameComplete = false
                IsGameOver = false
                endScreen.stopMusic()
                startScreen.startMusic()
            end
        end
    else
        if(key == "return") then
            isGameStarted = true
            isGameComplete = false
            isBossLoaded = false
            startScreen.stopMusic()
            background.startMusic()
        end
    end
end