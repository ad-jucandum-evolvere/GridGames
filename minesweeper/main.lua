if arg[#arg] == "debug" then
    require("lldebugger").start()
end

function love.load()
    Object = require("lib.vendor.classic")
    require("lib.common.grid")
    require("lib.common.cell")

    love.window.setTitle("Minesweeper")

    local cell_size = 30
    local grid_resolution = love.graphics.getHeight() / cell_size
    -- local left = love.graphics.getWidth() / 2 - (grid_resolution * cell_size / 2)
    -- local top = love.graphics.getHeight() / 2 - (grid_resolution * cell_size / 2)

    grid = Grid:new(0, 0, grid_resolution, cell_size)
end

function love.draw()
    grid:draw()
end

function love.update(dt)
    grid:update(dt)
end

function love.mousepressed(x, y, button)
    -- if left mouse button is pressed
    if button == 1 then
        -- start toggling the item value
        grid:toggleCell(x, y)
    end
end


