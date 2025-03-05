Cell = Object:extend()

---constructor
---@param x number
---@param y number
---@param size number
---@param value number
function Cell:new(x, y, size, value)
    local cell = {}

    setmetatable(cell, self);

    cell.x = x or 0
    cell.y = y or 0
    cell.size = size or 0
    cell.value = value or 0

    return cell
end

function Cell:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.size, self.size)

    love.graphics.setColor(1, 1, 1, 1)
    local offset = -(self.size / 2) + 2; -- TODO: Need to fix this to align to center
    love.graphics.print(self.value, self.x, self.y, 0, 1, 1, offset, offset)
end

function Cell:update()
    -- love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.rectangle("line", self.x, self.y, self.size, self.size)

    -- love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.print(self.value)
end



