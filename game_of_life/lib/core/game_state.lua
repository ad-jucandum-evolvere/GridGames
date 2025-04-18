--- imports
vector2 = require("fwk.graphics.vector2")
padding = require("fwk.graphics.padding")
container = require("fwk.graphics.container")
timer = require("fwk.utils.timer")
board = require("lib.entity.board")

--- Manager for game state and timers
local gs = {}

---@type board
local gameBoard = nil
---@type table<string|integer, timer>
local timers = {}
local alignmentVector = vector2.new()
local scalingFactor = 1
local isPaused = true
local isStartScreen = true
local isMuted = false
local isFullScreen = false
local stateUpdateQueue = {}
local cellSize = 8
local originalWidth, originalHeight = love.window.getMode()
local newWidth, newHeight = originalWidth, originalHeight

-- Images
local instructionSprite = love.graphics.newImage("resources/sprites/instructions.png")
local pauseImage = love.graphics.newImage("resources/sprites/pause.png")
local playImage = love.graphics.newImage("resources/sprites/play.png")

--- Audio
local pauseSound = love.audio.newSource("resources/audio/off.ogg", "static")
local playSound = love.audio.newSource("resources/audio/on.ogg", "static")
local bgm = love.audio.newSource("resources/audio/lost in the meadows_0.flac", "stream")

---clean up expired timers from list
---@param index number
local function cleanUpTimers(index)
    timers[index] = nil
    stateUpdateQueue[index] = nil
end

---update game state notification
local function gameStateNotification()
    local stateSprite = isPaused and pauseImage or playImage
    local stateSound = isPaused and pauseSound or playSound
    stateSound:play()
    local notificationTimer = timer.new(0.2, timer.TimerType.AFTER, cleanUpTimers, #timers + 1)
    timers[#timers + 1] = notificationTimer
    stateUpdateQueue[#timers] = stateSprite
end

---initialize
function gs.init()
    bgm:setLooping(true)
    bgm:play()
    gameBoard = board.new(vector2.new(), vector2.new(originalWidth - 4, originalHeight - 4), padding.new(10), cellSize)
    local generationTimer = timer.new(0.1, timer.TimerType.EVERY, gameBoard.updateState, gameBoard)
    timers["generationTimer"] = generationTimer
end

---draw event handler
function gs.drawHandler()
    love.graphics.push()
    alignmentVector.x = (newWidth - gameBoard.dimension.x * scalingFactor) / 2
    alignmentVector.y = (newHeight - gameBoard.dimension.y * scalingFactor) / 2
    love.graphics.translate(alignmentVector.x, alignmentVector.y)
    love.graphics.scale(scalingFactor, scalingFactor)
    gameBoard:draw()
    love.graphics.pop()

    for key, stateSprite in pairs(stateUpdateQueue) do
        love.graphics.draw(stateSprite, newWidth / 2, newHeight / 2, 0, 1, 1, 50, 50)
    end
    if isStartScreen then
        love.graphics.draw(instructionSprite, newWidth / 2, newHeight / 2, 0, 1, 1, 150, 150)
    end
end

---update event handler
---@param dt number
function gs.updateHandler(dt)
    for key, gameTimer in pairs(timers) do
        if isPaused and key == "generationTimer" then
            goto continue
        end
        gameTimer:update(dt)
        ::continue::
    end
end

---window resize event handler
function gs.resizeHandler()
    newWidth, newHeight = love.window.getMode()
    local heightFactor = newHeight / originalHeight
    local widthFactor = newWidth / originalWidth
    scalingFactor = math.min(heightFactor, widthFactor)
end

---onClick event handler
---@param x number mouseX
---@param y number mouseY
---@param button number buttonPressed
function gs.onClickHandler(x, y, button)
    if isStartScreen then
        isStartScreen = false
        bgm:play()
        return
    end
    if button == 1 then
        ---@type vector2
        local scaledMouseVector = vector2.new(x - alignmentVector.x, y - alignmentVector.y) / scalingFactor
        gameBoard:onClickHandler(scaledMouseVector.x, scaledMouseVector.y)
    end
end

---onKeyPress event handler
---@param key string keyPressed
function gs.onKeyPressHandler(key)
    if key == "f11" then
        isFullScreen = not isFullScreen
        love.window.setFullscreen(isFullScreen)
        return
    end
    if isStartScreen then
        isStartScreen = false
        if key == "escape" then
            love.event.quit(0)
        end
        bgm:play()
    end
    if key == "space" then
        isPaused = not isPaused
        gameStateNotification()
    elseif key == "r" then
        gameBoard:reset()
    elseif key == "m" then
        isMuted = not isMuted
        local volumeLevel = isMuted and 0.0 or 1.0
        love.audio.setVolume(volumeLevel)
    elseif key == "escape" then
        bgm:pause()
        isStartScreen = true
    end
end

return gs
