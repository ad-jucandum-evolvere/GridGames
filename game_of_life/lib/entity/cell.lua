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
    if self.isAlive then
        self:addGlow(cellAliveColor, 120, 2, 4)
        love.graphics.setColor(cellAliveColor)
    else
        love.graphics.setColor(cellDeadColor)
    end
    self:fillContent()
    love.graphics.setColor(Colors.white)
    love.graphics.pop()
end

-- function cell:windowResizeHandler(factor)
--     self.sf = factor
-- end

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

function cell:updateState()
    self.isAlive = self.nextState
    self.nextState = nil
end

return cell
