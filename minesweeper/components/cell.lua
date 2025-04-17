--- @class Cell
local Cell = {}
Cell.__index = Cell

function Cell.new(x, y, size, value, debug_mode)
    --- @class Cell
    local self = setmetatable({}, Cell)
    self.x = x or 0
    self.y = y or 0
    self.size = size or 0
    self.value = value or -1
    self.hidden = true
    self.flagged = false
    self.complete = false

    local function loadImage(path)
        local info = love.filesystem.getInfo(path)
        if info then
            return love.graphics.newImage(path)
        end
    end

    local function drawImage(path)
        image = loadImage(path)
        factor = self.size * 0.6
        scale = factor / image:getWidth()
        offsetX = (self.size - (image:getWidth() * scale)) / 2
        offsetY = (self.size - (image:getHeight() * scale)) / 2
        love.graphics.push()
        love.graphics.draw(image, self.x + offsetX, self.y + offsetY, 0, scale, scale)
        love.graphics.pop()
    end

    local function resetColor()
        love.graphics.setColor(1, 1, 1, 1)
    end

    local function setDefaultBorder()
        resetColor()
        love.graphics.setColor(0.7, 0.7, 0.7, 1)
        love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
    end

    local function showCellFlag()
        resetColor()
        drawImage("assets/flag.png")
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
        if self.complete then
            love.graphics.setColor(0, 0.5, 0, 1)
            love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
        else
            love.graphics.setColor(0.5, 0, 0, 1)
            love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
        end
        if self.flagged == false then
            resetColor()
            drawImage("assets/mine.png")
        end
    end

    local function setDarkerFill()
        if self.value == 0 then
            love.graphics.setColor(0.3, 0.3, 0.3, 1)
        else
            love.graphics.setColor(0.25, 0.25, 0.25, 1)
        end
        love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
    end

    local function setDarkerBackground()
        setDefaultBorder()
        setDarkerFill()
    end

    local function showCellTextValue()
        resetColor()
        love.graphics.push()
        local vertical_offset = love.graphics.getFont():getHeight() / 2
        local offset = -(self.size / 2) + vertical_offset
        local text = ""
        if self.value == 10000 then
            text = ""
        elseif self.value > 0 and self.value < 10000 then
            text = self.value
        end
        love.graphics.printf(text, self.x, self.y, self.size, "center", 0, 1, 1, 0, offset)
        love.graphics.pop()
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


        if debug_mode == true then
            showCellTextValue()
        end
    end

    return self
end

return Cell
