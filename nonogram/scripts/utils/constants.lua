-- imports
local color = require("fwk.graphics.color")

---@class constants
local constants = {
    CELL_SIZE = 15, ---@type integer
    BACKGROUND_COLOR = color.new("#888888"), ---@type color

    ---@enum difficulty
    DIFFICULTY = {
        EASY = "Easy", ---@type string
        NORMAL = "Normal", ---@type string
        HARD = "Hard", ---@type string
    }
}

---create a proxy to implement constants as read-only
---@param t constants
---@return constants
local function readOnly(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function(table, key, value)
            error("attempt to update " .. key .. " a constant value", 2)
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

return readOnly(constants)
