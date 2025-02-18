---@class padding
---@field left number
---@field top number
---@field right number
---@field bottom number
local padding = {}
local padding_mt = { __index = padding }

---convert to string
---@param self padding
---@return string
local function toString(self)
    return "[" .. self.left .. ", " .. self.top .. ", " .. self.right .. ", " .. self.bottom .. "]"
end

---scale padding by factor
---@operator mul(number): vector2
---@param this padding
---@param factor number
---@return padding
local function mul(this, factor)
    local res = padding.new()
    for k, v in pairs(this) do
        if type(k) ~= "function" then
            res[k] = v * factor
        end
    end
    return res
end

padding_mt.__mul = mul
padding_mt.__tostring = toString

---constructor
---@param ... any
---@return padding
function padding.new(...)
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
    }, padding_mt)
end

---pre-fabricator
---@param padding padding
---@return padding
function padding.copy(padding)
    local copy = padding.new(padding.left, padding.top, padding.right, padding.bottom)
    return setmetatable(copy, getmetatable(padding))
end

return padding
