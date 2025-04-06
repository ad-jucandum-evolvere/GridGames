local Minesweeper = {}
Minesweeper.__index = Minesweeper

local MINE = 10000
local EMPTY = 0

function Minesweeper.new(mines)
    local Cell = require("src.cell")

    local self = setmetatable({}, Minesweeper)
    self.state = {}
    self.state.cell_size = 50
    self.state.board_resolution = love.graphics.getHeight() / self.state.cell_size
    self.state.mines_count = mines
    ---@type Cell[][]
    self.state.cells = {}
    self.state.has_clicked_mine = false

    local mine_positions = {}

    local function generateAdjacentCells()
        for i = 1, self.state.board_resolution do
            for j = 1, self.state.board_resolution do
                if self.state.cells[i][j].value ~= MINE then
                    local adjacent_mines = 0
                    local cells = self.state.cells
                    -- top left
                    if i > 1 and j > 1 and cells[i - 1][j - 1].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    -- top
                    if j > 1 and cells[i][j - 1].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    -- top right
                    if i < self.state.board_resolution and j > 1 and cells[i + 1][j - 1].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end

                    -- left
                    if i > 1 and cells[i - 1][j].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end

                    -- right
                    if i < self.state.board_resolution and cells[i + 1][j].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end

                    -- bottom left
                    if i > 1 and j < self.state.board_resolution and cells[i - 1][j + 1].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    -- bottom
                    if j < self.state.board_resolution and cells[i][j + 1].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    -- bottom right
                    if i < self.state.board_resolution and j < self.state.board_resolution and cells[i + 1][j + 1].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    cells[i][j].value = adjacent_mines
                end
            end
        end
    end

    local function generateMines()
        for c = 1, self.state.mines_count do
            local i = math.random(1, self.state.board_resolution)
            local j = math.random(1, self.state.board_resolution)
            local x = ((i - 1) * self.state.cell_size)
            local y = ((j - 1) * self.state.cell_size)
            print(i, j, x, y)
            self.state.cells[i][j].value = MINE
            mine_positions[c] = { i, j }
        end
        generateAdjacentCells()
    end

    local function generateEmptyCells()
        for i = 1, self.state.board_resolution do
            local x = ((i - 1) * self.state.cell_size)
            self.state.cells[i] = {}
            for j = 1, self.state.board_resolution do
                local y = ((j - 1) * self.state.cell_size)
                self.state.cells[i][j] = Cell.new(x, y, self.state.cell_size, EMPTY);
            end
        end
        -- print(getmetatable(self.state.cells[1][1]) == getmetatable(self.state.cells[1][2]))
        generateMines()
    end

    function self:draw()
        for i = 1, self.state.board_resolution do
            for j = 1, self.state.board_resolution do
                local cell = self.state.cells[i][j]
                cell:draw()
            end
        end
    end

    function self:updateCell(x, y)
        if self.state.has_clicked_mine == false then
            local i = math.floor(x / self.state.cell_size) + 1
            local j = math.floor(y / self.state.cell_size) + 1
            if self.state.cells[i][j].hidden == true then
                self.state.cells[i][j].hidden = false
            end
            if self.state.cells[i][j].value == MINE then
                self.state.has_clicked_mine = true;
                for c, v in ipairs(mine_positions) do
                    self.state.cells[v[1]][v[2]].hidden = false
                end
            end
        end
    end

    generateEmptyCells()

    return self
end

return Minesweeper
