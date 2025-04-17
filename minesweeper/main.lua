if arg[#arg] == "debug" then
    require("lldebugger").start()
end

function love.load()
    -- make sure that the random number generation is randomized
    math.randomseed(os.time())
    local Minesweeper = require("src.minesweeper")

    love.window.setTitle("Minesweeper")
    game = Minesweeper.new(10, 10, "hard")
end

function love.draw()
    game:draw()
end

function love.mousepressed(x, y, button)
    game:mousepressed(x, y, button)
end



