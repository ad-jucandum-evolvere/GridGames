if arg[#arg] == "debug" then
    require("lldebugger").start()
end

-- imports
vector2 = require("fwk.graphics.vector2")
padding = require("fwk.graphics.padding")
color = require("fwk.graphics.color")
container = require("fwk.graphics.container")
timer = require("fwk.utils.timer")
board = require("lib.entity.board")

-- common colors enum
Colors = color.Color

local widthOriginal, heightOriginal = love.window.getMode()

function love.load()
    love.window.setTitle("Game of Life")
    delayTimer = timer.new(3, timer.TimerType.AFTER, print, "Delay")
    local cellSize = 10
    mainBoard = board.new(vector2.new(), vector2.new(widthOriginal - 20, heightOriginal - 20), padding.new(10), cellSize)
    generationTimer = timer.new(0.1, timer.TimerType.EVERY, mainBoard.updateState, mainBoard)
end

function love.draw()
    mainBoard:draw()
end

function love.resize()
    local newWidth, newHeight = love.window.getMode()
    local factor, pow = nil, 1
    factor = newHeight / heightOriginal
    mainBoard:windowResizeHandler(math.pow(factor, pow))
end

function love.mousepressed(x, y, button, isTouch)
    if button == 1 then
        mainBoard:onClickHandler(x, y)
    end
end

function love.keypressed(key)
    if key == "space" then
        mainBoard:toggleGameState()
    end
end

function love.update(dt)
    delayTimer:update(dt)
    generationTimer:update(dt)
end
