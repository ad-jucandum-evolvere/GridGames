if arg[#arg] == "debug" then
    require("lldebugger").start()
end

function love.load()
    Object = require("lib.vendor.classic")
    require("minesweeper.src.game_state")
    require("src.cell")

    love.window.setTitle("Minesweeper")
    love.window.setMode(500, 500)

    game = Game:new()
end

function love.draw()
    game:draw()
end

function love.update(dt)
    game:update(dt)
end



