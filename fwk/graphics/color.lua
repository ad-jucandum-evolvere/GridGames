---@class color
---@field colorValues table
local color = {}
local color_mt = { __index = color }

---checks whether string is empty or not
---@param str string
---@return string|nil
local function isEmpty(str)
    if str == "" or str == nil then
        return nil
    end
    return str
end

---constructor
---@param colorHex string hex string for color. supports rgb or rgba values
---@return color
function color.new(colorHex)
    local colorPattern = "^#(%x%x)(%x%x)(%x%x)(%x?%x?)"
    local _, _, red, green, blue, alpha = string.find(colorHex, colorPattern)
    red = red and tonumber(red, 16) or 255
    green = green and tonumber(green, 16) or 255
    blue = blue and tonumber(blue, 16) or 255
    alpha = isEmpty(alpha) or "ff"
    alpha = tonumber(alpha, 16)
    return setmetatable({ red / 255, green / 255, blue / 255, alpha / 255 }, color_mt)
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

---@enum Colors
color.Colors = {
    black = color.new("#000000"),
    white = color.new("#ffffff"),
    gray = color.new("#888888"),
    red = color.new("#ff0000"),
    green = color.new("#00ff00"),
    blue = color.new("#0000ff")
}

return color
