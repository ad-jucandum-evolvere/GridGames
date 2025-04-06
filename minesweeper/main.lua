if arg[#arg] == "debug" then
    require("lldebugger").start()
end

function love.load()
    math.randomseed(os.time())
    for i = 1, 3 do math.random() end
    local Minesweeper = require("src.minesweeper")

    love.window.setTitle("Minesweeper")
    love.window.setMode(500, 500)

    game = Minesweeper.new(10)
end

function love.draw()
    game:draw()
end

function love.mousepressed(x, y, button)
    if button == 1 then
        game:updateCell(x, y)
    end
end



