---@class Cell: Pod
---@field currentState boolean
---@field nextState boolean
local Cell = Pod.new()
local Cell_mt = { __index = Cell }

local cellDeadColor = Color.new({ 84, 40, 54 })
local cellAliveColor = Color.new({ 24, 99, 173 })

---constructor
---@param origin Vector2
---@param size Vector2
---@param pad Padding
---@return Cell
function Cell.new(origin, size, pad)
    origin = origin or Vector2.new()
    pad = pad or Padding.new()
    size = size or Vector2.new()
    return setmetatable({
        origin = origin,
        dimension = size,
        pad = pad,
        currentState = false,
        nextState = false
    }, Cell_mt)
end

---draw cell
function Cell:draw()
    love.graphics.push()
    self:translateToOrigin()
    if self.currentState then
        love.graphics.setColor(cellAliveColor)
    else
        love.graphics.setColor(cellDeadColor)
    end
    self:fillContent()
    love.graphics.setColor(Color.color.white)
    love.graphics.pop()
end

function Cell:resize(factor)
    self.origin = self.origin * factor
    self.dimension = self.dimension * factor
end

---mouse click handler
function Cell:clicked(mouseX, mouseY)
    local x, y = mouseX - self.origin.x, mouseY - self.origin.y
    local width, height = self:getDimensions()
    if x < width and y < height then
        self.currentState = not self.currentState
    end
end

---compute next state of cell
---@param neighbors Cell[]
function Cell:computeNextState(neighbors)
    local neighborCount = 0
    for i = 1, #neighbors do
        if neighbors[i] ~= nil then
            if neighbors[i].currentState then neighborCount = neighborCount + 1 end
        end
    end
    if self.currentState then
        if neighborCount < 2 then
            self.nextState = false
        elseif neighborCount == 2 or neighborCount == 3 then
            self.nextState = true
        else
            self.nextState = false
        end
    else
        if neighborCount == 3 then
            self.nextState = true
        end
    end
end

function Cell:updateState()
    self.currentState = self.nextState
    self.nextState = nil
end

return Cell
