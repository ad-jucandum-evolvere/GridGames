--- imports
cell = require("lib.entity.cell")

---@class board: container
---@field cells cell[][]
---@field cellsDimension vector2
local board = container.new()
local board_mt = { __index = board }

---get neighboring cells
---@param cells cell[][]
---@param i number
---@param j number
---@return cell[]
local function getNeighbors(cells, i, j)
    ---@type number[][]
    local neighborOffset = { { -1, -1 }, { -1, 0 }, { -1, 1 }, { 0, -1 }, { 0, 1 }, { 1, -1 }, { 1, 0 }, { 1, 1 } }
    local neighbors = {}
    local index = 1
    for itr = 1, #neighborOffset do
        local neighborRow = cells[i + neighborOffset[itr][1]]
        if neighborRow and neighborRow[j + neighborOffset[itr][2]] then
            neighbors[index] = neighborRow[j + neighborOffset[itr][2]]
            index = index + 1
        end
    end
    return neighbors
end

---constructor
---@param origin vector2
---@param dimension vector2
---@param pad padding
---@param cellSize number
---@return board
function board.new(origin, dimension, pad, cellSize)
    origin = origin or vector2.new()
    dimension = dimension or vector2.new()
    pad = pad or padding.new()
    cellSize = cellSize or 10

    local cells = {}
    local cellsPerRow = math.floor((dimension.x - (pad.left + pad.right)) / cellSize)
    local cellsPerColumn = math.floor((dimension.y - (pad.top + pad.bottom)) / cellSize)
    for i = 1, cellsPerColumn do
        cells[i] = {}
        for j = 1, cellsPerRow do
            local cellOx = pad.left + (j - 1) * cellSize
            local cellOy = pad.top + (i - 1) * cellSize
            cells[i][j] = cell.new(vector2.new(cellOx, cellOy), vector2.new(cellSize, cellSize),
                padding.new())
        end
    end
    local newDimension = vector2.new(pad.left + pad.right + cellsPerRow * cellSize,
        pad.top + pad.bottom + cellsPerColumn * cellSize)

    return setmetatable({
        origin = origin,
        dimension = newDimension,
        pad = pad,
        cells = cells,
        cellsDimension = vector2.new(cellsPerRow, cellsPerColumn)
    }, board_mt)
end

---draw board
function board:draw()
    if #self.cells <= 0 then
        return
    end
    love.graphics.push()
    self:translateToOrigin()
    self:drawMarginRounded(5)
    love.graphics.setColor(Colors.black)
    self:fillContent()
    love.graphics.setColor(Colors.white)

    for i = 1, #self.cells do
        for j = 1, #self.cells[i] do
            self.cells[i][j]:draw()
        end
    end
    love.graphics.pop()
end

---reset board
function board:reset()
    if #self.cells <= 0 then
        return
    end
    for i = 1, #self.cells do
        for j = 1, #self.cells[i] do
            self.cells[i][j].isAlive = false
        end
    end
end

---update state of board and cells
function board:updateState()
    for i = 1, #self.cells do
        for j = 1, #self.cells[i] do
            self.cells[i][j]:computeNextState(getNeighbors(self.cells, i, j))
        end
    end
    for i = 1, #self.cells do
        for j = 1, #self.cells[i] do
            self.cells[i][j]:updateState()
        end
    end
end

---binary search cell array
---@param axis string
---@param array cell[]
---@param low number
---@param high number
---@param value number
local function binarySearch(axis, array, low, high, value)
    while low <= high do
        local mid = low + math.floor((high - low) / 2)
        local found = array[mid]:withinBounds(value, axis)

        if found == 0 then
            return mid
        elseif found == 1 then
            low = mid + 1
        else
            high = mid - 1
        end
    end
    return 0
end

local function binaryCellIndexSearch(cells, x, y)
    local tempArray = {}
    for i = 1, #cells do
        tempArray[i] = cells[i][1]
    end
    local cell_i = binarySearch("y", tempArray, 1, #tempArray, y)
    local cell_j = binarySearch("x", cells[1], 1, #cells[1], x)
    return cell_i, cell_j
end


---handle onClick event
---@param mouseX number
---@param mouseY number
function board:onClickHandler(mouseX, mouseY)
    local x = mouseX - self.origin.x
    local y = mouseY - self.origin.y
    local i, j = binaryCellIndexSearch(self.cells, x, y)
    if i == 0 or j == 0 then
        return
    end
    self.cells[i][j]:onClickHandler()
end

return board
