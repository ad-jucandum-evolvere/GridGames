Cell = require("lib.core.cell")

---@class Board
---@field origin Point
---@field pad Padding
---@field cells Cell[]
local Board = {}
local Board_mt = { __index = Board }

--@private
---get the limiting side of the display window
---@return number
local function getLimitingFactor()
    local windowWidth, windowHeight, flags = love.window.getMode()
    if windowHeight < windowWidth then
        return windowHeight
    else
        return windowWidth
    end
end

---@private
---compute cell size when window resizes
---@param cellCount number
---@return number
local function getCellSize(cellCount)
    local limitingFactor = getLimitingFactor()
    local cellDimension = math.floor(math.sqrt(cellCount))
    return (limitingFactor - 2 * 10) / cellDimension
end

---constructor
---@param origin Point
---@param pad Padding
---@param cellSize number
---@param cellCount number
---@return Board
function Board.new(origin, pad, cellSize, cellCount)
    origin = origin or Point.new()
    pad = pad or Padding.new()
    cellSize = cellSize or 10
    cellCount = cellCount or 100

    local cells = {}
    local cellsPerRow = math.floor(math.sqrt(cellCount))
    for n = 0, cellCount - 1 do
        local i = n % cellsPerRow
        local j = math.floor(n / cellsPerRow)
        local cellOx = origin.x + pad.left + i * cellSize
        local cellOy = origin.y + pad.top + j * cellSize
        cells[n + 1] = Cell.new(Point.new(cellOx, cellOy), Padding.new(1), cellSize)
    end

    return setmetatable({
        origin = origin,
        pad = pad,
        cells = cells
    }, Board_mt)
end

function Board:draw()
    if #self.cells <= 0 then
        print("no cells to draw")
        return
    end
    local cellsPerRow = math.floor(math.sqrt(#self.cells))
    local boardSize = self.cells[1].size * cellsPerRow
    love.graphics.push()
    love.graphics.translate(self.origin.x, self.origin.y)
    love.graphics.rectangle("fill", self.pad.left, self.pad.top, boardSize, boardSize)
    love.graphics.pop()

    for n = 1, #self.cells do
        self.cells[n]:draw()
    end
end

function Board:resize()
    local cellCount = #self.cells
    local cellSize = getCellSize(cellCount)
    local cellsPerRow = math.floor(math.sqrt(cellCount))
    for n = 0, cellCount - 1 do
        local i = n % cellsPerRow
        local j = math.floor(n / cellsPerRow)
        local cellOx = self.origin.x + self.pad.left + i * cellSize
        local cellOy = self.origin.y + self.pad.top + j * cellSize
        self.cells[n + 1].origin.x = cellOx
        self.cells[n + 1].origin.y = cellOy
        self.cells[n + 1].size = cellSize
    end
end

function Board:mousePressed(mouseX, mouseY)
    local cellSize = self.cells[1].size
    local cellDimension = math.floor(math.sqrt(#self.cells))
    local x = mouseX - self.origin.x - self.pad.left
    local y = mouseY - self.origin.y - self.pad.top
    if x > cellSize * cellDimension or y > cellSize * cellDimension then
        --mouse is out of bounds
        return
    end
    local i = math.floor(x / cellSize)
    local j = math.floor(y / cellSize)
    local cellIndex = j * cellDimension + i + 1
    self.cells[cellIndex]:clicked()
end

return Board
