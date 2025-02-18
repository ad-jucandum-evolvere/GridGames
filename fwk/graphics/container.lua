---@class container
---@field origin vector2
---@field dimension vector2
---@field pad padding
local container = {}
local container_mt = { __index = container }

---constructor
---@return container
function container.new()
    return setmetatable({
        origin = vector2.new(),
        dimension = vector2.new(),
        pad = padding.new()
    }, container_mt)
end

---compute content dimension of the container
---@return number width
---@return number height
function container:getContentDimension()
    local width = self.dimension.x - (self.pad.left + self.pad.right)
    local height = self.dimension.y - (self.pad.top + self.pad.bottom)
    return width, height
end

function container:fillContent()
    local width, height = self:getContentDimension()
    love.graphics.rectangle("fill", self.pad.left, self.pad.top, width, height)
end

function container:fillContentRounded(rd)
    local width, height = self:getContentDimension()
    love.graphics.rectangle("fill", self.pad.left, self.pad.top, width, height, rd, rd)
end

---add glow for the container
---@param color color
---@param alpha number
---@param size number
---@param rd? number
function container:addGlow(color, alpha, size, rd)
    local width, height = self:getContentDimension()
    love.graphics.setColor(color:setAlpha(alpha))
    if rd then
        love.graphics.rectangle("fill", self.pad.left - size, self.pad.top - size, width + size * 2, height + size * 2,
            rd, rd)
    else
        love.graphics.rectangle("fill", self.pad.left - size, self.pad.top - size, width + size * 2, height + size * 2)
    end
    love.graphics.setColor(color:resetAlpha())
end

function container:drawMargin()
    love.graphics.rectangle("line", 0, 0, self.dimension.x, self.dimension.y)
end

function container:drawMarginRounded(rd)
    love.graphics.rectangle("line", 0, 0, self.dimension.x, self.dimension.y, rd, rd)
end

function container:getDimensions()
    return self.dimension.x, self.dimension.y
end

function container:translateToOrigin()
    love.graphics.translate(self.origin.x, self.origin.y)
end

return container
