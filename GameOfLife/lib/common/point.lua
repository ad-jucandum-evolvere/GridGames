---@class Point
---@overload fun()
---@overload fun(x: number, y:number)
---@overload fun(p: Point)
---@field x number
---@field y number
local Point = {}
local Point_mt = { __index = Point }

---toString
---@param self Point
---@return string
local function toString(self)
    return "(" .. self.x .. "," .. self.y .. ")"
end

---sum of current point and given point
---@operator add(Point): Point
---@param this Point
---@param that Point
---@return Point
local function add(this, that)
    local res = Point.new()
    res.x = this.x + that.x
    res.y = this.y + that.y
    return res
end

---difference between current point and given point
---@operator sub(Point): Point
---@param this Point
---@param that Point
---@return Point
local function sub(this, that)
    local res = Point.new()
    res.x = this.x - that.x
    res.y = this.y - that.y
    return res
end

Point_mt.__add = add
Point_mt.__sub = sub
Point_mt.__tostring = toString


---default constructor
---@return Point
function Point.new()
    return setmetatable({
        x = 0,
        y = 0
    }, Point_mt)
end

---parameterized constructor
---@overload fun()
---@param x number
---@param y number
---@return Point
function Point.new(x, y)
    x = x or 0
    y = y or 0
    return setmetatable({
        x = x,
        y = y
    }, Point_mt)
end

---pre-fabricator
---@param point Point
---@return Point
function Point.copy(point)
    local copy = Point.new(point.x, point.y)
    return setmetatable(copy, getmetatable(point))
end

---distance between current point and given point
---@param this Point
---@param that Point
---@return number
function Point.dist(this, that)
    local xDiff = this.x - that.x
    local yDiff = this.y - that.y
    return math.sqrt(math.pow(xDiff, 2) + math.pow(yDiff, 2))
end

return Point
