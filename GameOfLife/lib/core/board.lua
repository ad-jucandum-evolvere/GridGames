Cell = require("lib.core.cell")

---@class Board: Pod
---@field cells Cell[]
---@field cellsDimension Vector2
---@field gameRunning boolean
local Board = Pod.new()
local Board_mt = { __index = Board }

---get neighboring cells
---@param this Board
---@param i number
---@param j number
---@return Cell[]
local function getNeighbors(this, i, j)
    local neighbors = {}
    local cellsPerRow = this.cellsDimension.x
    neighbors[1] = this.cells[(i - 1) * cellsPerRow + j]
    neighbors[2] = this.cells[i * cellsPerRow + j]
    neighbors[3] = this.cells[(i + 1) * cellsPerRow + j]
    neighbors[4] = this.cells[(i - 1) * cellsPerRow + j + 1]
    neighbors[5] = this.cells[(i + 1) * cellsPerRow + j + 1]
    neighbors[6] = this.cells[(i - 1) * cellsPerRow + j + 2]
    neighbors[7] = this.cells[i * cellsPerRow + j + 2]
    neighbors[8] = this.cells[(i + 1) * cellsPerRow + j + 2]
    return neighbors
end

---constructor
---@param origin Vector2
---@param dimension Vector2
---@param pad Padding
---@param cellSize number
---@return Board
function Board.new(origin, dimension, pad, cellSize)
    origin = origin or Vector2.new()
    dimension = dimension or Vector2.new()
    pad = pad or Padding.new()
    cellSize = cellSize or 10

    local cells = {}
    local cellsPerRow = math.ceil((dimension.x - (pad.left + pad.right)) / cellSize)
    local cellsPerColumn = math.ceil((dimension.y - (pad.top + pad.bottom)) / cellSize)
    for i = 0, cellsPerRow - 1 do
        for j = 0, cellsPerColumn - 1 do
            local cellOx = pad.left + i * cellSize
            local cellOy = pad.top + j * cellSize
            cells[i * cellsPerRow + j + 1] = Cell.new(Vector2.new(cellOx, cellOy), Vector2.new(cellSize, cellSize),
                Padding.new(1))
        end
    end
    local newDimension = Vector2.new(pad.left + pad.right + cellsPerRow * cellSize,
        pad.top + pad.bottom + cellsPerColumn * cellSize)

    return setmetatable({
        origin = origin,
        dimension = newDimension,
        pad = pad,
        cells = cells,
        cellsDimension = Vector2.new(cellsPerRow, cellsPerColumn),
        gameRunning = false
    }, Board_mt)
end

function Board:draw()
    if #self.cells <= 0 then
        print("no cells to draw")
        return
    end

    love.graphics.push()
    self:translateToOrigin()
    self:drawMarginRounded(5)
    love.graphics.setColor(Color.color.black)
    self:fillContent()
    love.graphics.setColor(Color.color.white)

    for i = 0, self.cellsDimension.x - 1 do
        for j = 0, self.cellsDimension.y - 1 do
            self.cells[i * self.cellsDimension.x + j + 1]:draw()
        end
    end
    love.graphics.pop()
end

function Board:resize(factor)
    self.origin = self.origin * factor
    self.dimension = self.dimension * factor
    for i = 0, self.cellsDimension.x - 1 do
        for j = 0, self.cellsDimension.y - 1 do
            self.cells[i * self.cellsDimension.x + j + 1]:resize(factor)
        end
    end
end

function Board:toggleGameState()
    self.gameRunning = not self.gameRunning
end

function Board:updateState()
    if not self.gameRunning then
        return
    end
    local cellsPerRow, cellsPerColumn = self.cellsDimension.x, self.cellsDimension.y
    for i = 0, cellsPerRow - 1 do
        for j = 0, cellsPerColumn - 1 do
            self.cells[i * cellsPerRow + j + 1]:computeNextState(getNeighbors(self, i, j))
        end
    end
    for i = 0, cellsPerRow - 1 do
        for j = 0, cellsPerColumn - 1 do
            self.cells[i * cellsPerRow + j + 1]:updateState()
        end
    end
end

function Board:mousePressed(mouseX, mouseY)
    local x = mouseX - self.origin.x - self.pad.left
    local y = mouseY - self.origin.y - self.pad.top
    if x > self.dimension.x or y > self.dimension.y then
        --mouse is out of bounds
        return
    end
    local cellSize = self.cells[1]:getDimensions()
    local i = math.floor(x / cellSize)
    local j = math.floor(y / cellSize)
    local cellIndex = i * self.cellsDimension.x + j + 1
    self.cells[cellIndex]:clicked(x, y)
end

return Board
