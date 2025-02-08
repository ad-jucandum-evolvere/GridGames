Container = Object:extend()

---constructor
---@param x number
---@param y number
---@param width number
---@param height number
function Container:new(x, y, width, height, offset)
    local container = {}

    setmetatable(container, self);

    container.x = x or 0
    container.y = y or 0
    container.width = width or 10
    container.height = height or 10
    container.player = Player:new(container.x, container.y, 20, 20, offset)

    return container;
end

function Container:update(dt)
    self.player:update(dt)
end

function Container:draw()
    self.player:draw()
end

function Container:keypressed(key)
    self.player:handleKeyPress(key)
end
