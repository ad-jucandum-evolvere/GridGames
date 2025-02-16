Color = require("lib.common.color")

---@class Cell
---@field origin Point
---@field pad Padding
---@field size number
---@field currentState boolean
---@field nextState boolean
local Cell = {}
local Cell_mt = { __index = Cell }

local cellDeadColor = Color.new({ 84, 40, 54 })
local cellAliveColor = Color.new({ 24, 99, 173 })


---constructor
---@param origin Point
---@param pad Padding
---@param size number
---@return Cell
function Cell.new(origin, pad, size)
    origin = origin or Point.new()
    pad = pad or Padding.new()
    size = size or 10
    return setmetatable({
        origin = origin,
        pad = pad,
        size = size,
        currentState = false
    }, Cell_mt)
end

---draw cell
function Cell:draw()
    local width = self.size - (self.pad.left + self.pad.right)
    local height = self.size - (self.pad.top + self.pad.bottom)
    love.graphics.push()
    love.graphics.translate(self.origin.x, self.origin.y)
    if self.currentState then
        love.graphics.setColor(cellAliveColor)
    else
        love.graphics.setColor(cellDeadColor)
    end
    love.graphics.rectangle("fill", self.pad.left, self.pad.top, width, height)
    love.graphics.setColor({ 0, 0, 0 })
    love.graphics.pop()
end

---mouse click handler
function Cell:clicked()
    self.currentState = not self.currentState
end

function Cell:computeNextState()
    self.nextState = not self.currentState
end

function Cell:updateState()
    self.currentState = self.nextState
end

return Cell
