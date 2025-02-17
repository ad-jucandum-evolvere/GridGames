---@class Vector2
---@field x number
---@field y number
local Vector2 = {}
local Vector2_mt = { __index = Vector2 }

---toString
---@param self Vector2
---@return string
local function toString(self)
    return "(" .. self.x .. "," .. self.y .. ")"
end

---sum of current point and given point
---@operator add(Vector2): Vector2
---@param this Vector2
---@param that Vector2
---@return Vector2
local function add(this, that)
    local res = Vector2.new()
    res.x = this.x + that.x
    res.y = this.y + that.y
    return res
end

---difference between current point and given point
---@operator sub(Vector2): Vector2
---@param this Vector2
---@param that Vector2
---@return Vector2
local function sub(this, that)
    local res = Vector2.new()
    res.x = this.x - that.x
    res.y = this.y - that.y
    return res
end

---scale Vector2 by factor
---@operator mul(number): Vector2
---@param this Vector2
---@param factor number
---@return Vector2
local function mul(this, factor)
    local res = Vector2.new()
    for k, v in pairs(this) do
        if type(k) ~= "function" then
            res[k] = v * factor
        end
    end
    return res
end

Vector2_mt.__add = add
Vector2_mt.__sub = sub
Vector2_mt.__mul = mul
Vector2_mt.__tostring = toString

---default constructor
---@overload fun(x: number, y:number): Vector2
---@return Vector2
function Vector2.new()
    return setmetatable({
        x = 0,
        y = 0
    }, Vector2_mt)
end

---parameterized constructor for different x, y values
---@param x number
---@param y number
---@return Vector2
function Vector2.new(x, y)
    x = x or 0
    y = y or 0
    return setmetatable({
        x = x,
        y = y
    }, Vector2_mt)
end

---pre-fabricator
---@param point Vector2
---@return Vector2
function Vector2.copy(point)
    local copy = Vector2.new(point.x, point.y)
    return setmetatable(copy, getmetatable(point))
end

---distance between current point and given point
---@param this Vector2
---@param that Vector2
---@return number
function Vector2.dist(this, that)
    local xDiff = this.x - that.x
    local yDiff = this.y - that.y
    return math.sqrt(math.pow(xDiff, 2) + math.pow(yDiff, 2))
end

return Vector2
