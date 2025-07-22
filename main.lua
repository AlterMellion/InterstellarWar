-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

love.window.setTitle("Interstellar War")

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
local powerups = require("powerups")

IsGameOver = false
local GameOverLoaded = false
local sleepTimer = 0
local isGameStarted = false
local isGameComplete = false
local isBossLoaded = false
local bossInstance

local currentLevel = 1
local maxLevels
local decodedConfig

function ResetGame()
    continue.resetCountdown()
    enemyShips.reset()
    spaceship.load()
    score.load()
end

function DrawEngineSplashScreen()    
    local love2d = love.graphics.newImage('pics/Love2d.png')
    love.graphics.draw(love2d, ScreenWidth/2, ScreenHeight/2, 0, 1, 1, love2d:getWidth()/2, love2d:getHeight()/2)
    love.graphics.present()
    
    love.timer.sleep(3)
end

function DrawStudioSplashScreen()
    local burro = love.graphics.newImage('pics/burro.png')
    love.graphics.draw(burro, ScreenWidth/2, ScreenHeight/2, 0, 1, 1, burro:getWidth()/2, burro:getHeight()/2)
    local helper = require("helper")
    helper.outlineText("Burro Studio", 0, burro:getHeight() *2)
    love.graphics.present()

    love.timer.sleep(3)
end

function LoadFont()
    local font = love.graphics.newFont("fonts/pixelmix.ttf", 35)
    love.graphics.setFont(font)
end

function LoadLevel(level)
    background.load(level)
    explosions.load()
    playerShots.load()
    spaceship.load()
    enemyShip.load(level)
    enemyShips.load()
    boss.loadConfig(level)
end

function love.load()
    LoadFont()
    --DrawEngineSplashScreen()
    --DrawStudioSplashScreen()

    score.load()
    powerups.load()
    config.load()
    startScreen.load()
    audio.load()
    
    decodedConfig = config.get()
    maxLevels = #decodedConfig["levels"]
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
                if not background.IsLevelNameDisplayed() then
                    enemyShips.spawn(dt)
                end
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
                isBossLoaded = false
                currentLevel = currentLevel + 1
                if currentLevel > maxLevels then
                    isGameComplete = true
                    return
                end
                enemyShips.reset()       
                boss.playTheme(false)
                LoadLevel(currentLevel)
                background.startMusic()
                return
            end
        end
        
        enemyShips.move(dt)
        powerups.update(dt)
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
        
        powerups.draw()
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

function GetCurrentLevel()
    --decodedConfig
end

function love.keypressed(key)
    if isGameStarted then
        if key == "space" then
            if not isGameComplete and 
               not background.IsLevelNameDisplayed() and
               not boss.isAppearing() then
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
            LoadLevel(currentLevel)
            
            isGameStarted = true
            isGameComplete = false
            isBossLoaded = false
            startScreen.stopMusic()
            background.startMusic()
        end
    end
end