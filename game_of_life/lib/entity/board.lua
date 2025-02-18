--- imports
cell = require("lib.entity.cell")

---@class board: container
---@field cells cell[][]
---@field cellsDimension vector2
---@field gameRunning boolean
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
    for i = 1, cellsPerRow do
        cells[i] = {}
        for j = 1, cellsPerColumn do
            local cellOx = pad.left + (i - 1) * cellSize
            local cellOy = pad.top + (j - 1) * cellSize
            cells[i][j] = cell.new(vector2.new(cellOx, cellOy), vector2.new(cellSize, cellSize),
                padding.new(1))
        end
    end
    local newDimension = vector2.new(pad.left + pad.right + cellsPerRow * cellSize,
        pad.top + pad.bottom + cellsPerColumn * cellSize)

    return setmetatable({
        origin = origin,
        dimension = newDimension,
        pad = pad,
        cells = cells,
        cellsDimension = vector2.new(cellsPerRow, cellsPerColumn),
        gameRunning = false,
        sf = 1
    }, board_mt)
end

function board:draw()
    if #self.cells <= 0 then
        print("no cells to draw")
        return
    end

    love.graphics.push()
    love.graphics.scale(self.sf, self.sf)
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

function board:windowResizeHandler(factor)
    self.sf = factor
    -- for i = 1, #self.cells do
    --     for j = 1, #self.cells[i] do
    --         self.cells[i][j]:windowResizeHandler(factor)
    --     end
    -- end
end

function board:toggleGameState()
    self.gameRunning = not self.gameRunning
end

function board:updateState()
    if not self.gameRunning then
        return
    end
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

function board:onClickHandler(mouseX, mouseY)
    local x = mouseX - self.origin.x - self.pad.left
    local y = mouseY - self.origin.y - self.pad.top
    local cellSize = self.cells[1][1]:getDimensions() * self.sf
    local i = math.ceil(x / cellSize)
    local j = math.ceil(y / cellSize)
    if i < 0 or i > self.cellsDimension.x or j < 0 or j > self.cellsDimension.y then
        return
    end
    self.cells[i][j]:onClickHandler()
end

return board
