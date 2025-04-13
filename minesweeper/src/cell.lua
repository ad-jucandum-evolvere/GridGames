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
    self.flagged = false

    local function loadImage(path)
        local info = love.filesystem.getInfo(path)
        if info then
            return love.graphics.newImage(path)
        end
    end

    local function resetColor()
        love.graphics.setColor(1, 1, 1, 1)
    end

    local function setDefaultBorder()
        resetColor()
        love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
    end

    local function showCellFlag()
        resetColor()
        image = loadImage("assets/flag.png")
        factor = self.size * 0.6
        scale = factor / image:getWidth()
        offsetX = (self.size - (image:getWidth() * scale)) / 2
        offsetY = (self.size - (image:getHeight() * scale)) / 2
        love.graphics.push()
        love.graphics.draw(image, self.x + offsetX, self.y + offsetY, 0, scale, scale)
        love.graphics.pop()
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
        local vertical_offset = love.graphics.getFont():getHeight() / 2
        local offset = -(self.size / 2) + vertical_offset
        love.graphics.printf((self.value == 10000) and "M" or self.value, self.x, self.y, self.size, "center", 0, 1, 1, 0, offset)
    end

    function self:draw()
        if self.value == 10000 then -- Mine
            if self.hidden == false then
                setMineCellColor()
                if self.flagged == true then
                    showCellFlag()
                end
            else
                setDefaultCellColor()
                if self.flagged == true then
                    showCellFlag()
                end
            end
        elseif self.value == 0 then
            if self.hidden == false then
                setDarkerBackground()
                if self.flagged == true then
                    showCellFlag()
                else
                    showCellTextValue()
                end
            else
                setDefaultCellColor()
                if self.flagged == true then
                    showCellFlag()
                end
            end
        else
            if self.hidden == false then
                setDarkerBackground()
                if self.flagged == true then
                    showCellFlag()
                else
                    showCellTextValue()
                end
            else
                setDefaultCellColor()
                if self.flagged == true then
                    showCellFlag()
                end
            end
        end


        if DEBUG_MODE == true then
            showCellTextValue()
        end
    end

    return self
end

return Cell
