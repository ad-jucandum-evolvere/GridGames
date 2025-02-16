---@class Timer
---@field elapsed number
---@field time number
---@field callback function
---@field args any
---@field update function
local Timer = {}
local Timer_mt = { __index = Timer }

---check whether the parameter callable is a function
---@param callback function
---@return boolean
local function isCallable(callback)
    local callbackType = type(callback)
    if callbackType == "function" then return true end
    if callbackType == "table" then
        local metaTable = getmetatable(callback)
        return type(metaTable) == "table" and type(metaTable.__call) == "function"
    end
    return false
end

---check whether the given number is positive
---@param name string
---@param value number
local function checkPositiveInteger(name, value)
    if type(value) ~= "number" or value < 0 then
        error(name .. "must be a positive integer")
    end
end

---function that executes callback after 'time' seconds
---@param self Timer
---@param dt number
---@return boolean
local function updateAfterClock(self, dt)
    checkPositiveInteger("dt", dt)
    if self.elapsed >= self.time then return true end

    self.elapsed = self.elapsed + dt

    if self.elapsed >= self.time then
        self.callback(unpack(self.args))
        return true
    end
    return false
end

---function that executes call every 'time' seconds
---@param self Timer
---@param dt number
---@return boolean
local function updateEveryClock(self, dt)
    checkPositiveInteger("dt", dt)
    self.elapsed = self.elapsed + dt

    if self.elapsed >= self.time then
        self.callback(unpack(self.args))
        self.elapsed = self.elapsed - self.time
    end
    return false
end

---@enum TimerType
Timer.TimerType = {
    AFTER = updateAfterClock,
    EVERY = updateEveryClock
}

---creates a new timer of required type which callbacks once it elapsed time reaches required time
---@param time number
---@param timerType TimerType
---@param callback function
---@param ... any
---@return Timer
function Timer.new(time, timerType, callback, ...)
    assert(isCallable(callback), "callback is not a function")
    return setmetatable({
        elapsed = 0,
        time = time,
        update = timerType,
        callback = callback,
        args = { ... }
    }, Timer_mt)
end

---reset timer to 0 or given value
---@param value number
function Timer:reset(value)
    value = value or 0
    checkPositiveInteger("value", value)
    self.elapsed = value
end

return Timer
