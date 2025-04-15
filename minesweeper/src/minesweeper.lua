local Minesweeper = {}
Minesweeper.__index = Minesweeper

local MINE = 10000
local EMPTY = 0
local CASCADE_EFFECT = false
local DEBUG_MODE = false

function Minesweeper.new(gridX, gridY, difficulty)
    local Cell = require("src.cell")

    local self = setmetatable({}, Minesweeper)
    local grid_x = math.max(3, math.min(gridX, 25))
    local grid_y = math.max(3, math.min(gridY, 15))
    local percentage = (difficulty == "medium" and 0.15) or (difficulty == "easy" and 0.1) or 0.2
    local size = 50

    love.graphics.setNewFont(20)
    love.window.setMode(grid_x * size, grid_y * size)
    self.state = {}
    self.state.mines_count = math.floor((grid_x * grid_y) * percentage)
    self.state.non_mines = (grid_x * grid_y) - self.state.mines_count

    ---@type Cell[][]
    self.state.cells = {}
    self.state.has_clicked_mine = false
    self.state.game_menu_open = false

    local font = love.graphics.getFont()
    local mine_positions = {}
    local buttonWidth = 200
    local buttonHeight = 40

    local function generateAdjacentCells()
        for i = 1, grid_x do
            for j = 1, grid_y do
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
                    if i < grid_x and j > 1 and cells[i + 1][j - 1].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end

                    -- left
                    if i > 1 and cells[i - 1][j].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end

                    -- right
                    if i < grid_x and cells[i + 1][j].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end

                    -- bottom left
                    if i > 1 and j < grid_y and cells[i - 1][j + 1].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    -- bottom
                    if j < grid_y and cells[i][j + 1].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    -- bottom right
                    if i < grid_x and j < grid_y and cells[i + 1][j + 1].value == MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    cells[i][j].value = adjacent_mines
                end
            end
        end
    end

    local function generateRandomMine(count)
        if (count > self.state.mines_count) then
            return
        end
        local i = math.random(1, grid_x)
        local j = math.random(1, grid_y)
        if self.state.cells[i][j].value ~= MINE then
            mine_positions[count] = { i, j }
            self.state.cells[i][j].value = MINE
            generateRandomMine(count + 1)
        else
            generateRandomMine(count)
        end
    end

    local function generateMines()
        generateRandomMine(1)
        generateAdjacentCells()
    end

    local function generateGame()
        for i = 1, grid_x do
            local x = ((i - 1) * size)
            self.state.cells[i] = {}
            for j = 1, grid_y do
                local y = ((j - 1) * size)
                self.state.cells[i][j] = Cell.new(x, y, size, EMPTY, DEBUG_MODE);
            end
        end
        generateMines()
    end

    local function revealCell(i, j)
        self.state.cells[i][j].hidden = false
        self.state.non_mines = self.state.non_mines - 1
    end

    local function openCell(x, y)
        if self.state.game_menu_open == false then
            if self.state.has_clicked_mine == false then
                local i = math.floor(x / size) + 1
                local j = math.floor(y / size) + 1
                self.state.cells[i][j].flagged = false
                if self.state.cells[i][j].hidden == true then
                    if CASCADE_EFFECT == true then
                        revealCell(i, j)
                    else
                        self.state.cells[i][j].hidden = false
                        self.state.non_mines = self.state.non_mines - 1
                    end
                end
                if self.state.cells[i][j].value == MINE then
                    self.state.has_clicked_mine = true
                    for c, v in ipairs(mine_positions) do
                        self.state.cells[v[1]][v[2]].hidden = false
                    end
                    self.state.game_menu_open = true
                end
                if self.state.has_clicked_mine == false and self.state.non_mines == 0 then
                    for c, v in ipairs(mine_positions) do
                        self.state.cells[v[1]][v[2]].hidden = false
                        self.state.cells[v[1]][v[2]].complete = true
                    end
                    self.state.game_menu_open = true
                end
            end
        end
    end

    local function flagCell(x, y)
        if self.state.has_clicked_mine == false and self.state.game_menu_open == false then
            local i = math.floor(x / size) + 1
            local j = math.floor(y / size) + 1
            if self.state.cells[i][j].hidden == true then
                if self.state.cells[i][j].flagged == false then
                    self.state.cells[i][j].flagged = true
                else
                    self.state.cells[i][j].flagged = false
                end
            end
        end
    end

    function self:draw()
        for i = 1, grid_x do
            for j = 1, grid_y do
                local cell = self.state.cells[i][j]
                cell:draw()
            end
        end
        if self.state.game_menu_open == true then
            love.graphics.setColor(100, 100, 100, 0.6);
            local width, height = love.window.getMode()
            local modalWidth = math.min(400, width)
            local modalHeight = math.min(200, height)
            local x = (width / 2) - (modalWidth / 2)
            local y = (height / 2) - (modalHeight / 2)
            love.graphics.rectangle("fill", x, y, modalWidth, modalHeight)

            love.graphics.setColor(0, 0, 0)
            local text = "Click the Button to restart the game";
            local textWidth = font:getWidth(text)
            local textX = (width / 2) - (textWidth / 2)
            local textY = (height / 2) - (modalHeight / 4)
            love.graphics.print(text, textX, textY)

            love.graphics.setColor(255, 255, 255)
            local buttonX = (width / 2) - (buttonWidth / 2)
            local buttonY = (height / 2) - (buttonHeight / 2)
            love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
            love.graphics.setColor(0, 0, 0)
        end
    end

    function love.mousepressed(x, y, button)
        if self.state.game_menu_open == true then
            -- button logic here
            local width, height = love.window.getMode()
            local buttonX = (width / 2) - (buttonWidth / 2)
            local buttonY = (height / 2) - (buttonHeight / 2)
            if x > buttonX and x < buttonX + buttonWidth and y > buttonY and y < buttonY + buttonWidth then
                self.state.cells = {};
                self.state.has_clicked_mine = false
                self.state.mines_count = math.floor((grid_x * grid_y) * percentage)
                self.state.non_mines = (grid_x * grid_y) - self.state.mines_count
                generateGame()
                self.state.game_menu_open = false
            end
        else
            if button == 1 then
                openCell(x, y)
            elseif button == 2 then
                flagCell(x, y)
            end
        end

    end

    generateGame()

    return self
end

return Minesweeper
