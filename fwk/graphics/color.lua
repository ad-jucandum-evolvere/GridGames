---@class color
---@field rgba table
local color = {}
local color_mt = { __index = color }

---constructor
---@param rgba table contains rgb or rgba values
---@return color
function color.new(rgba)
    local o = {}
    for i, v in ipairs(rgba) do
        o[i] = v / 255
    end
    return setmetatable(o, color_mt)
end

---set alpha value
---@param alpha number
---@return color
function color:setAlpha(alpha)
    self[4] = alpha / 255
    return self
end

---reset color alpha
---@return color
function color:resetAlpha()
    self[4] = 1
    return self
end

---@enum Color
color.Color = {
    black = color.new({ 0, 0, 0 }),
    white = color.new({ 255, 255, 255 }),
    red = color.new({ 255, 0, 0 }),
    green = color.new({ 0, 255, 0 }),
    blue = color.new({ 0, 0, 255 })
}

return color
