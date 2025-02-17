---@class Pod
---@field origin Vector2
---@field dimension Vector2
---@field pad Padding
local Pod = {}
local Pod_mt = { __index = Pod }

---constructor
---@return Pod
function Pod.new()
    return setmetatable({
        origin = Vector2.new(),
        dimension = Vector2.new(),
        pad = Padding.new()
    }, Pod_mt)
end

---compute content dimension of the container
---@param self Pod
---@return number width
---@return number height
local function getContentDimension(self)
    local width = self.dimension.x - (self.pad.left + self.pad.right)
    local height = self.dimension.y - (self.pad.top + self.pad.bottom)
    return width, height
end

function Pod:fillContent()
    local width, height = getContentDimension(self)
    love.graphics.rectangle("fill", self.pad.left, self.pad.top, width, height)
end

function Pod:fillContentRounded(rd)
    local width, height = getContentDimension(self)
    love.graphics.rectangle("fill", self.pad.left, self.pad.top, width, height, rd, rd)
end

function Pod:drawMargin()
    love.graphics.rectangle("line", 0, 0, self.dimension.x, self.dimension.y)
end

function Pod:drawMarginRounded(rd)
    love.graphics.rectangle("line", 0, 0, self.dimension.x, self.dimension.y, rd, rd)
end

function Pod:getDimensions()
    return self.dimension.x, self.dimension.y
end

function Pod:translateToOrigin()
    love.graphics.translate(self.origin.x, self.origin.y)
end

return Pod
