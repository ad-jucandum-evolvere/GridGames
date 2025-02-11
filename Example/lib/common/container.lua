Container = Object:extend()

---constructor
---@param x number
---@param y number
---@param width number
---@param height number
---@param padding number
function Container:new(x, y, width, height, padding)
    local container = {}

    setmetatable(container, self);

    container.x = x or 0
    container.y = y or 0
    container.width = width or 10
    container.height = height or 10
    container.padding = padding or 0

    return container
end

function Container:update(dt)
    -- self.update(dt)
end

function Container:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

-- function Container:keypressed(key)
--     self.player:handleKeyPress(key)
-- end
