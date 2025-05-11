-- imports
local constants = require("scripts.utils.constants")

if arg[#arg] == "debug" then
    require("lldebugger").start()
end

function love.load()
end

function love.draw(delta)
    love.graphics.push()
    love.graphics.setColor(constants.BACKGROUND_COLOR)
    love.graphics.rectangle("fill", 0, 0, constants.CELL_SIZE, constants.CELL_SIZE)
    love.graphics.pop()
    love.graphics.reset()
    love.graphics.rectangle("fill", 100, 100, constants.CELL_SIZE, constants.CELL_SIZE)
end
