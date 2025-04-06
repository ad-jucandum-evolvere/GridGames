--- @class Cell
local Cell = {}
Cell.__index = Cell

local DEBUG_MODE = true
function Cell.new(x, y, size, value)
    --- @class Cell
    local self = setmetatable({}, Cell)
    self.x = x or 0
    self.y = y or 0
    self.size = size or 0
    self.value = value or -1
    self.hidden = true

    local function resetColor()
        love.graphics.setColor(1, 1, 1, 1)
    end

    local function setDefaultBorder()
        resetColor()
        love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
    end

    local function setDefaultFill()
        resetColor()
        love.graphics.setColor(0.4, 0.4, 0.4, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
    end

    local function setDefaultCellColor()
        setDefaultBorder()
        setDefaultFill()
    end

    local function setMineCellColor()
        setDefaultBorder()
        love.graphics.setColor(0.5, 0, 0, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
    end

    local function setDarkerFill()
        setDefaultBorder()
        love.graphics.setColor(0.25, 0.25, 0.25, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
    end

    local function setDarkerBackground()
        setDefaultBorder()
        setDarkerFill()
    end

    local function showCellTextValue()
        resetColor()
        local offset = -(self.size / 2) + 2  -- TODO: Adjust to center the text properly
        love.graphics.print((self.value == 10000) and "M" or self.value, self.x, self.y, 0, 1, 1, offset, offset)
    end

    function self:draw()
        if self.value == 10000 then -- Mine
            if self.hidden == false then
                setMineCellColor()
            else
                setDefaultCellColor()
            end
        elseif self.value == 0 then
            if self.hidden == false then
                setDarkerBackground()
                showCellTextValue()
            else
                setDefaultCellColor()
            end
        else
            if self.hidden == false then
                setDarkerBackground()
                showCellTextValue()
            else
                setDefaultCellColor()
            end
        end


        if DEBUG_MODE == true then
            showCellTextValue()
        end
    end

    return self
end

return Cell
