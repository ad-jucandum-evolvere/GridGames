if arg[#arg] == "debug" then
    require("lldebugger").start()
end

Padding = require("lib.common.padding")
Point = require("lib.common.point")
Timer = require("lib.common.timer")
Board = require("lib.core.board")

--@private
---get the limiting side of the display window
---@return number
local function getLimitingFactor()
    local windowWidth, windowHeight, flags = love.window.getMode()
    if windowHeight < windowWidth then
        return windowHeight
    else
        return windowWidth
    end
end

function love.load()
    love.window.setTitle("Game of Life")
    delayTimer = Timer.new(3, Timer.TimerType.AFTER, print, "Delay")
    everyTimer1 = Timer.new(13, Timer.TimerType.EVERY, print, "13")
    everyTimer = Timer.new(10, Timer.TimerType.EVERY, Timer.reset, delayTimer)
    local limitingFactor = getLimitingFactor()
    local cellDimension = 50
    local cellSize = (limitingFactor - 2 * 10) / cellDimension
    mainBoard = Board.new(Point.new(), Padding.new(10), cellSize, math.pow(cellDimension, 2))
end

function love.draw()
    mainBoard:draw()
end

function love.resize()
    mainBoard:resize()
end

function love.mousepressed(x, y, button, isTouch)
    if button == 1 then
        mainBoard:mousePressed(x, y)
    end
end

function love.update(dt)
    delayTimer:update(dt)
    everyTimer:update(dt)
    everyTimer1:update(dt)
end
