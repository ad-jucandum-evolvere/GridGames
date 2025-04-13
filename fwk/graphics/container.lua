-- Experimental

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

---fills container with current color
function container:fillContent()
    local width, height = self:getContentDimension()
    love.graphics.rectangle("fill", self.pad.left, self.pad.top, width, height)
end

---fills container with current color with rounded corners
---@param rd number
function container:fillContentRounded(rd)
    local width, height = self:getContentDimension()
    love.graphics.rectangle("fill", self.pad.left, self.pad.top, width, height, rd, rd)
end

---add glow for the container
---@param color color
---@param alpha number
---@param size number
---@param isRounded? boolean
function container:innerGlow(color, alpha, size, isRounded)
    ---@type vector2
    local glowDimension = vector2.new(self:getContentDimension()) - vector2.new(size)
    local glowOrigin = vector2.new(self.pad.left, self.pad.right) + vector2.new(size / 2)
    love.graphics.setColor(color:setAlpha(alpha))
    love.graphics.setLineWidth(size)
    if isRounded then
        love.graphics.rectangle("line", glowOrigin.x, glowOrigin.y, glowDimension.x, glowDimension.y, size, size)
    else
        love.graphics.rectangle("line", glowOrigin.x, glowOrigin.y, glowDimension.x, glowDimension.y)
    end
    love.graphics.setLineWidth(1)
    love.graphics.setColor(color:resetAlpha())
end

---draw margin
function container:drawMargin()
    love.graphics.rectangle("line", 0, 0, self.dimension.x, self.dimension.y)
end

---draw rounded margin
---@param rd number
function container:drawMarginRounded(rd)
    love.graphics.rectangle("line", 0, 0, self.dimension.x, self.dimension.y, rd, rd)
end

---get the content dimensions
---@return number width
---@return number height
function container:getDimensions()
    return self.dimension.x, self.dimension.y
end

---translate to container's origin
function container:translateToOrigin()
    love.graphics.translate(self.origin.x, self.origin.y)
end

return container
