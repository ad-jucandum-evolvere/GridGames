---@class Color
---@field rgba table
local Color = {}
local Color_mt = { __index = Color }

function Color.new(rgba)
    local color = {}
    for i, v in ipairs(rgba) do
        color[i] = v / 255
    end
    return color
end

---@enum color
Color.color = {
    black = Color.new({ 0, 0, 0 }),
    white = Color.new({ 255, 255, 255 }),
    red = Color.new({ 255, 0, 0 }),
    green = Color.new({ 0, 255, 0 }),
    blue = Color.new({ 0, 0, 255 })
}

return Color
