---@class Padding
---@field left number
---@field top number
---@field right number
---@field bottom number
local Padding = {}
local Padding_mt = { __index = Padding }

---convert to string
---@param self Padding
---@return string
local function toString(self)
    return "[" .. self.left .. ", " .. self.top .. ", " .. self.right .. ", " .. self.bottom .. "]"
end

Padding_mt.__tostring = toString

---constructor
---@param ... any
---@return Padding
function Padding.new(...)
    local arg = { ... }
    if #arg > 4 then
        print("padding cannot have more than 4 arguments")
    end
    local left = arg[1] or 0
    local top = arg[2] or arg[1] or 0
    local right = arg[3] or arg[1] or 0
    local bottom = arg[4] or arg[2] or arg[1] or 0
    return setmetatable({
        left = left,
        top = top,
        right = right,
        bottom = bottom
    }, Padding_mt)
end

---pre-fabricator
---@param padding Padding
---@return Padding
function Padding.copy(padding)
    local copy = Padding.new(padding.left, padding.top, padding.right, padding.bottom)
    return setmetatable(copy, getmetatable(padding))
end

return Padding
