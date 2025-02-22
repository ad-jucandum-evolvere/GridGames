---@class vector2
---@field x number
---@field y number
local vector2 = {}
local vector2_mt = { __index = vector2 }

---toString
---@param self vector2
---@return string
local function toString(self)
    return "(" .. self.x .. "," .. self.y .. ")"
end

---sum of current point and given point
---@operator add(vector2): vector2
---@param this vector2
---@param that vector2
---@return vector2
local function add(this, that)
    local res = vector2.new()
    res.x = this.x + that.x
    res.y = this.y + that.y
    return res
end

---difference between current point and given point
---@operator sub(vector2): vector2
---@param this vector2
---@param that vector2
---@return vector2
local function sub(this, that)
    local res = vector2.new()
    res.x = this.x - that.x
    res.y = this.y - that.y
    return res
end

---scale Vector2 by factor
---@operator mul(number): vector2
---@param this vector2
---@param factor number
---@return vector2
local function mul(this, factor)
    local res = vector2.new()
    for k, v in pairs(this) do
        if type(k) ~= "function" then
            res[k] = v * factor
        end
    end
    return res
end

vector2_mt.__add = add
vector2_mt.__sub = sub
vector2_mt.__mul = mul
vector2_mt.__tostring = toString

---default constructor
---@overload fun(x: number, y?:number): vector2
---@return vector2
function vector2.new()
    return setmetatable({
        x = 0,
        y = 0
    }, vector2_mt)
end

---parameterized constructor for different x, y values
---@param x number
---@param y? number
---@return vector2
function vector2.new(x, y)
    x = x or 0
    y = y or x or 0
    return setmetatable({
        x = x,
        y = y
    }, vector2_mt)
end

---pre-fabricator
---@param prefab vector2
---@return vector2
function vector2.copy(prefab)
    local copy = vector2.new(prefab.x, prefab.y)
    return setmetatable(copy, getmetatable(prefab))
end

---distance between current point and given point
---@param this vector2
---@param that vector2
---@return number
function vector2.dist(this, that)
    local xDiff = this.x - that.x
    local yDiff = this.y - that.y
    return math.sqrt(math.pow(xDiff, 2) + math.pow(yDiff, 2))
end

return vector2
