if arg[#arg] == "debug" then
    require("lldebugger").start()
end

function love.load()
    math.randomseed(os.time())
    for i = 1, 3 do math.random() end
    local Minesweeper = require("src.minesweeper")

    love.window.setTitle("Minesweeper")
    game = Minesweeper.new(12, 12, "hard")
end

function love.draw()
    game:draw()
end



