local gs = {}

---@type board
local gameBoard = nil
---@type timer[]
local timers = {}
local alignmentVector = vector2.new()
local scalingFactor = 1
local isPaused = true
local originalWidth, originalHeight = love.window.getMode()
local newWidth, newHeight = originalWidth, originalHeight

function gs.init()
    local cellSize = 10
    gameBoard = board.new(vector2.new(), vector2.new(originalWidth - 10, originalHeight - 10), padding.new(10), cellSize)
    local generationTimer = timer.new(0.1, timer.TimerType.EVERY, gameBoard.updateState, gameBoard)
    timers[#timers + 1] = generationTimer
end

function gs.drawHandler()
    love.graphics.push()
    alignmentVector.x = (newWidth - gameBoard.dimension.x * scalingFactor) / 2
    alignmentVector.y = (newHeight - gameBoard.dimension.y * scalingFactor) / 2
    love.graphics.translate(alignmentVector.x, alignmentVector.y)
    love.graphics.scale(scalingFactor, scalingFactor)
    gameBoard:draw()
    love.graphics.pop()
end

function gs.updateHandler(dt)
    if isPaused then
        return
    end
    for i = 1, #timers do
        timers[i]:update(dt)
    end
end

function gs.resizeHandler()
    newWidth, newHeight = love.window.getMode()
    local heightFactor = newHeight / originalHeight
    local widthFactor = newWidth / originalWidth
    scalingFactor = math.min(heightFactor, widthFactor)
end

function gs.onClickHandler(x, y, button)
    if button == 1 then
        gameBoard:onClickHandler(x - alignmentVector.x, y - alignmentVector.y, scalingFactor)
    end
end

function gs.onKeyPressHandler(key)
    if key == "space" then
        isPaused = not isPaused
    elseif key == "r" then
        gameBoard:reset()
    end
end

return gs
