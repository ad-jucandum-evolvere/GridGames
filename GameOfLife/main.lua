if arg[#arg] == "debug" then
    require("lldebugger").start()
end

Vector2 = require("lib.common.vector2")
Padding = require("lib.common.padding")
Color = require("lib.common.color")
Pod = require("lib.common.pod")
Board = require("lib.core.board")
Timer = require("lib.common.timer")

local width, height = love.window.getMode()

function love.load()
    love.window.setTitle("Game of Life")
    delayTimer = Timer.new(3, Timer.TimerType.AFTER, print, "Delay")
    local cellSize = 10
    mainBoard = Board.new(Vector2.new(), Vector2.new(width - 20, height - 20), Padding.new(10), cellSize)
    everyTimer = Timer.new(0.5, Timer.TimerType.EVERY, mainBoard.updateState, mainBoard)
end

function love.draw()
    mainBoard:draw()
end

function love.resize()
    local newWidth, newHeight = love.window.getMode()
    local factor, pow = nil, 1
    if newHeight >= height then
        factor = newHeight / height
    else
        factor = height / newHeight
        pow = -1
    end
    mainBoard:resize(math.pow(factor, pow))
    width = newWidth
    height = newHeight
end

function love.mousepressed(x, y, button, isTouch)
    if button == 1 then
        mainBoard:mousePressed(x, y)
    end
end

function love.keypressed(key)
    if key == "space" then
        mainBoard:toggleGameState()
    end
end

function love.update(dt)
    delayTimer:update(dt)
    everyTimer:update(dt)
end
