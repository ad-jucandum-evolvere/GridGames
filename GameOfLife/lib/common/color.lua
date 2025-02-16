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

return Color
