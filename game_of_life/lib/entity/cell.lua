---@class cell: container
---@field isAlive boolean
---@field nextState boolean
local cell = container.new()
local cell_mt = { __index = cell }

local cellDeadColor = color.new("#542836")
local cellAliveColor = color.new("#1863ad")

--- cell audio
local cellClickSound = love.audio.newSource("resources/audio/button1.wav", "static")

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
    self:fillContentRounded(self.dimension.x / 2)
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
    love.audio.play(cellClickSound)
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

---check value is within x bound
---@param self cell
---@param value number
---@return integer
local function withinHorizontalBounds(self, value)
    local lower = self.origin.x
    local upper = lower + self.dimension.x
    if value > lower and value < upper then
        return 0
    elseif value < lower then
        return -1
    else
        return 1
    end
end

---check value is within y bound
---@param self cell
---@param value number
---@return integer
local function withinVerticalBounds(self, value)
    local lower = self.origin.y
    local upper = lower + self.dimension.y
    if value > lower and value < upper then
        return 0
    elseif value < lower then
        return -1
    else
        return 1
    end
end

---check whether give value is within bounds of corresponding axis
---@param value number
---@param axis string
---@return integer
function cell:withinBounds(value, axis)
    if axis == "x" then
        return withinHorizontalBounds(self, value)
    else
        return withinVerticalBounds(self, value)
    end
end

return cell
