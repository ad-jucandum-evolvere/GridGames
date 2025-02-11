if arg[#arg] == "debug" then
    require("lldebugger").start()
end

function love.load()
    Object = require("lib.vendor.classic")
    require("lib.common.container")
    require("lib.common.grid")
    require("lib.common.item")
    require("lib.entities.player")

    love.window.setTitle("Minesweeper")

    local item_size = 30
    local resolution = love.graphics.getHeight() / item_size
    -- local left = love.graphics.getWidth() / 2 - (resolution * item_size / 2)
    -- local top = love.graphics.getHeight() / 2 - (resolution * item_size / 2)

    grid = Grid:new(0, 0, resolution, item_size)
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


