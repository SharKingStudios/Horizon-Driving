-- The endscreen for the arcade loop

-- Scene container
gameEndscreen = {}

-- SUIT setup
local suit = require "SUIT"
-- local CScreen = require "cscreen"

-- misc. setup
local screenWidthA = love.graphics.getWidth()
local screenHeightA = love.graphics.getHeight()
local screenWidth = 1920
local screenHeight = 1080

-- Player Stats (All this stuff persists / changed to global variables)
-- local distanceTraveled = 0
-- local nearMisses = 0
-- local awesomeNearMisses = 0
-- local policeTakedowns = 0
-- local EMPDodges = 0
-- local timeSurvived = 0

local colorR = 0
local colorG = 0
local colorB = 0

function gameEndscreen.load()
    -- Set SUIT colors
    suit.theme.color.normal.fg = {255,255,255}
    suit.theme.color.hovered = {bg = {200,230,255}, fg = {0,0,0}}
    suit.theme.color.active = {bg = {150,150,150}, fg = {0,0,0}}

    -- Load font
    font = love.graphics.newFont("fonts/VCR_OSD_MONO.ttf", 100 * math.min(scaleStuff("w"), scaleStuff("h"))) -- The font
    font1 = love.graphics.newFont("fonts/VCR_OSD_MONO.ttf", 75 * math.min(scaleStuff("w"), scaleStuff("h")))
    font2 = love.graphics.newFont("fonts/VCR_OSD_MONO.ttf", 50 * math.min(scaleStuff("w"), scaleStuff("h")))
    font3 = love.graphics.newFont("fonts/VCR_OSD_MONO.ttf", 25 * math.min(scaleStuff("w"), scaleStuff("h")))
    love.graphics.setFont(font)
    
    -- Load sound(s)
    bgSong = love.audio.newSource("Sounds/bustedsong.wav", "static")
    bgSong:setVolume(0.4)
    bgSong:setLooping(true)

    -- Play bg song
    bgSong:play()

    -- Scaling init
    -- CScreen.init(math.max(love.graphics.getWidth(), 1920), 1080, debugMode)

    -- Update Highscores
    if distanceTraveled > gameData.distanceTraveledHIGHSCORE then gameData.distanceTraveledHIGHSCORE = distanceTraveled end -- TURNED OFF FOR DEBUGGING THINGIES
    if nearMisses > gameData.nearMissesHIGHSCORE then gameData.nearMissesHIGHSCORE = nearMisses end
    if awesomeNearMisses > gameData.awesomeNearMissesHIGHSCORE then gameData.awesomeNearMissesHIGHSCORE = awesomeNearMisses end
    if policeTakedowns > gameData.policeTakedownsHIGHSCORE then gameData.policeTakedownsHIGHSCORE = policeTakedowns end
    if EMPDodges > gameData.EMPDodgesHIGHSCORE then gameData.EMPDodgesHIGHSCORE = EMPDodges end
    if timeSurvived > gameData.timeSurvivedHIGHSCORE then gameData.timeSurvivedHIGHSCORE = timeSurvived end

    rectangleAnim = {
        x = 0,
        y = 0,
        width = screenWidthA,
        height = screenHeightA,
        speed = 300
    }
    colorR = 0
    colorG = 0
    colorB = 0
end

function gameEndscreen.update(dt)
    -- Prepare GUI
    suit.layout:reset(0, 0)

    love.graphics.setFont(font1)

    if suit.Button("Continue", (screenWidth - 425) * scaleStuff("w"), 25 * scaleStuff("h"), 400 * scaleStuff("w"), 100 * scaleStuff("h")).hit then
        bgSong:stop()
        return "mainMenu"
    end

    love.graphics.setFont(font1)
    
    -- Prepare the player statistics
    suit.Label("Scores:", {align = "left"},
    (25 * scaleStuff("w")), (25 * scaleStuff("h")), 800 * scaleStuff("w"), 150 * scaleStuff("h"))
    love.graphics.setFont(font2)
    local decimalPlaces = 2
    suit.Label("Distance Traveled: " .. roundNumber(distanceTraveled * 0.1 / 60, decimalPlaces), {align = "left"},
    (25 * scaleStuff("w")), (125 * scaleStuff("h")), 800 * scaleStuff("w"), 150 * scaleStuff("h"))
    suit.Label("Near Misses: " .. roundNumber(nearMisses, decimalPlaces), {align = "left"},
    (25 * scaleStuff("w")), (225 * scaleStuff("h")), 800 * scaleStuff("w"), 150 * scaleStuff("h"))
    suit.Label("Awesome Near Misses: " .. roundNumber(awesomeNearMisses, decimalPlaces), {align = "left"},
    (25 * scaleStuff("w")), (325 * scaleStuff("h")), 800 * scaleStuff("w"), 150 * scaleStuff("h"))
    suit.Label("Police Takedowns: " .. roundNumber(policeTakedowns, decimalPlaces), {align = "left"},
    (25 * scaleStuff("w")), (425 * scaleStuff("h")), 800 * scaleStuff("w"), 150 * scaleStuff("h"))
    suit.Label("EMP Dodges: " .. roundNumber(EMPDodges, decimalPlaces), {align = "left"},
    (25 * scaleStuff("w")), (525 * scaleStuff("h")), 800 * scaleStuff("w"), 150 * scaleStuff("h"))
    suit.Label("Time Survived: " .. roundNumber(timeSurvived, decimalPlaces), {align = "left"},
    (25 * scaleStuff("w")), (625 * scaleStuff("h")), 800 * scaleStuff("w"), 150 * scaleStuff("h"))
    

    if rectangleAnim.y < screenHeightA then
        rectangleAnim.y = rectangleAnim.y + rectangleAnim.speed * dt
    end

    colorR = colorR + 10 * dt
    colorG = colorG + 10 * dt
    colorB = colorB + 10 * dt

    if colorR >= 27 then colorR = 27 end
    if colorG >= 26 then colorG = 26 end
    if colorB >= 50 then colorB = 50 end

    return nil
end

function gameEndscreen.draw()
    love.graphics.clear(colorR/255, colorG/255, colorB/255)
    -- CScreen.apply()
    
    -- Draw GUI
    suit.draw()

    love.graphics.setColor(colorR/255, colorG/255, colorB/255)
    love.graphics.rectangle("fill", rectangleAnim.x, rectangleAnim.y, rectangleAnim.width, rectangleAnim.height)
    -- CScreen.cease()
end

function roundNumber(number, decimalPlaces) -- Currently just cuts it off at that specified decimal
    return math.floor(number * (math.pow(10, decimalPlaces))) / (math.pow(10, decimalPlaces))
end

function love.keypressed(key)
    if key == "1" then -- Exit the game (Debug)
      love.event.quit()
    end
end

-- function love.resize(width, height)
-- 	CScreen.update(width, height)
-- end

function scaleStuff(widthorheight)
    local scale = 1
    if widthorheight == "w" then -- width calc
        scale = screenWidthA / screenWidth
    elseif widthorheight == "h" then -- height calc
        scale = screenHeightA / screenHeight
    else
        print("Function usage error: scaleStuff() w/h not specified.")
    end

    return scale
end

return gameEndscreen