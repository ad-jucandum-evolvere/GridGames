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
gameState = require("lib.core.game_state")

-- common colors enum
Colors = color.Color

function love.load()
    love.window.setTitle("Game of Life")
    gameState.init()
end

function love.draw()
    gameState.drawHandler()
end

function love.resize()
    gameState.resizeHandler()
end

function love.mousepressed(x, y, button, isTouch)
    gameState.onClickHandler(x, y, button)
end

function love.keypressed(key)
    gameState.onKeyPressHandler(key)
end

function love.update(dt)
    gameState.updateHandler(dt)
end
