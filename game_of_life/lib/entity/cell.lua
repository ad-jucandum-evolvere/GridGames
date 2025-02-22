---@class cell: container
---@field isAlive boolean
---@field nextState boolean
local cell = container.new()
local cell_mt = { __index = cell }

local cellDeadColor = color.new({ 84, 40, 54 })
local cellAliveColor = color.new({ 24, 99, 173 })

---constructor
---@param origin vector2
---@param size vector2
---@param pad padding
---@return cell
function cell.new(origin, size, pad)
    origin = origin or vector2.new()
    pad = pad or padding.new()
    size = size or vector2.new()
    return setmetatable({
        origin = origin,
        dimension = size,
        pad = pad,
        isAlive = false,
        nextState = nil
    }, cell_mt)
end

---draw cell
function cell:draw()
    love.graphics.push()
    self:translateToOrigin()
    local cellColor = self.isAlive and cellAliveColor or cellDeadColor
    love.graphics.setColor(cellColor)
    self:fillContent()
    love.graphics.setColor(Colors.black)
    self:drawMargin()
    if self.isAlive then
        self:innerGlow(Colors.white, 40, 2, true)
    end
    love.graphics.setColor(Colors.white)
    love.graphics.pop()
end

---mouse click handler
function cell:onClickHandler()
    self.isAlive = not self.isAlive
end

---compute next state of cell
---@param neighbors cell[]
function cell:computeNextState(neighbors)
    local neighborCount = 0
    for i = 1, #neighbors do
        if neighbors[i] ~= nil then
            if neighbors[i].isAlive then neighborCount = neighborCount + 1 end
        end
    end
    if self.isAlive then
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

---update cell state
function cell:updateState()
    self.isAlive = self.nextState
    self.nextState = nil
end

local function withinXBound(self, x)
    local lower = self.origin.x
    local upper = lower + self.dimension.x
    if x > lower and x < upper then
        return 0
    elseif x < lower then
        return -1
    else
        return 1
    end
end

local function withinYBound(self, y)
    local lower = self.origin.y
    local upper = lower + self.dimension.y
    if y > lower and y < upper then
        return 0
    elseif y < lower then
        return -1
    else
        return 1
    end
end

function cell:withinBounds(value, axis)
    if axis == "x" then
        return withinXBound(self, value)
    else
        return withinYBound(self, value)
    end
end

return cell
