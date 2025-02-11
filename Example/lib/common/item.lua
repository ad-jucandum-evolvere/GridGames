Item = Object:extend()
timerCount = 0.2 -- milliseconds

---constructor
---@param x number
---@param y number
---@param size number
---@param value number
function Item:new(x, y, size, value)
    local item = {}

    setmetatable(item, self);

    item.x = x or 0
    item.y = y or 0
    item.size = size or 0
    item.value = value or 0
    item.timer = 0

    return item
end

function Item:update(dt)
    -- if self.value > 0 then
    --     self.timer = self.timer + dt
    --     if self.timer >= timerCount then
    --         self.value = math.max(0, self.value - 0.25)
    --         self.timer = 0
    --     end
    -- end
end

function Item:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.size, self.size)

    love.graphics.setColor(1, 1, 1, self.value)
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end


