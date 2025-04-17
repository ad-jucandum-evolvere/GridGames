local constants = require("lib.constants")
local grid = require("lib.grid")
local Cell = require("components.cell")

local Minesweeper = {}
Minesweeper.__index = Minesweeper

function Minesweeper.new(horizontal_cells, vertical_cells, diff)
    -- set font to bigger size and get font for alignments
    love.graphics.setNewFont(20)
    local font = love.graphics.getFont()

    -- minesweeper Board options
    local grid_x = grid.getHorizontalSize(horizontal_cells)
    local grid_y = grid.getVerticalSize(vertical_cells)
    local difficulty = grid.calculateGridDifficulty(diff)
    local size = constants.CELL_SIZE

    -- set the window to always adjust to the grid size
    love.window.setMode(grid_x * size, grid_y * size)

    -- initialize the game states
    local grid_size = horizontal_cells * vertical_cells
    ---@type Cell[][]
    local cells = {}
    local is_game_menu_open = false
    local has_clicked_mine = false
    local mine_positions = {}
    local mines = math.max(1, math.floor(grid_size * difficulty))
    local non_mines = grid_size - mines
    local buttonWidth = 200
    local buttonHeight = 40

    local self = setmetatable({}, Minesweeper)

    -- private methods
    local function generateAdjacentCells()
        for i = 1, grid_x do
            for j = 1, grid_y do
                if cells[i][j].value ~= constants.MINE then
                    local adjacent_mines = 0
                    -- top left
                    if i > 1 and j > 1 and cells[i - 1][j - 1].value == constants.MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    -- top
                    if j > 1 and cells[i][j - 1].value == constants.MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    -- top right
                    if i < grid_x and j > 1 and cells[i + 1][j - 1].value == constants.MINE then
                        adjacent_mines = adjacent_mines + 1
                    end

                    -- left
                    if i > 1 and cells[i - 1][j].value == constants.MINE then
                        adjacent_mines = adjacent_mines + 1
                    end

                    -- right
                    if i < grid_x and cells[i + 1][j].value == constants.MINE then
                        adjacent_mines = adjacent_mines + 1
                    end

                    -- bottom left
                    if i > 1 and j < grid_y and cells[i - 1][j + 1].value == constants.MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    -- bottom
                    if j < grid_y and cells[i][j + 1].value == constants.MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    -- bottom right
                    if i < grid_x and j < grid_y and cells[i + 1][j + 1].value == constants.MINE then
                        adjacent_mines = adjacent_mines + 1
                    end
                    cells[i][j].value = adjacent_mines
                end
            end
        end
    end

    local function generateRandomMine(count)
        if (count > mines) then
            return
        end
        local i = math.random(1, grid_x)
        local j = math.random(1, grid_y)
        if cells[i][j].value ~= constants.MINE then
            mine_positions[count] = { i, j }
            cells[i][j].value = constants.MINE
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
            cells[i] = {}
            for j = 1, grid_y do
                local y = ((j - 1) * size)
                cells[i][j] = Cell.new(x, y, size, constants.EMPTY, false);
            end
        end

        generateMines()
    end

    -- using flood fill algorithm to open blank cells
    local function revealCell(i, j)
        if i >= 1 and i <= grid_x and j >= 1 and j <= grid_y and cells[i][j].hidden == true then
            cells[i][j].hidden = false
            cells[i][j].flagged = false
            non_mines = non_mines - 1

            if cells[i][j].value == constants.EMPTY then
                revealCell(i - 1, j - 1) -- top left
                revealCell(i, j - 1) -- top
                revealCell(i + 1, j - 1) -- top right

                revealCell(i - 1, j) -- left
                revealCell(i + 1, j) -- right

                revealCell(i - 1, j + 1) -- bottom left
                revealCell(i, j + 1) -- bottom
                revealCell(i + 1, j + 1) -- bottom right
            end
        end
    end

    local function openCell(x, y)
        if is_game_menu_open == false then
            if has_clicked_mine == false then
                local i = math.floor(x / size) + 1
                local j = math.floor(y / size) + 1
                cells[i][j].flagged = false

                revealCell(i, j)
                if cells[i][j].value == constants.MINE then
                    has_clicked_mine = true
                    for c, v in ipairs(mine_positions) do
                        cells[v[1]][v[2]].hidden = false
                    end
                    is_game_menu_open = true
                end
                if has_clicked_mine == false and non_mines == 0 then
                    for c, v in ipairs(mine_positions) do
                        cells[v[1]][v[2]].hidden = false
                        cells[v[1]][v[2]].complete = true
                    end
                    is_game_menu_open = true
                end
            end
        end
    end

    local function flagCell(x, y)
        if has_clicked_mine == false and is_game_menu_open == false then
            local i = math.floor(x / size) + 1
            local j = math.floor(y / size) + 1
            if cells[i][j].hidden == true then
                if cells[i][j].flagged == false then
                    cells[i][j].flagged = true
                else
                    cells[i][j].flagged = false
                end
            end
        end
    end

    generateGame()

    -- public methods
    function self:draw()
        for i = 1, grid_x do
            for j = 1, grid_y do
                local cell = cells[i][j]
                cell:draw()
            end
        end
        if is_game_menu_open == true then
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

    function self:mousepressed(x, y, button)
        if is_game_menu_open == true then
            -- button logic here
            local width, height = love.window.getMode()
            local buttonX = (width / 2) - (buttonWidth / 2)
            local buttonY = (height / 2) - (buttonHeight / 2)
            if x > buttonX and x < buttonX + buttonWidth and y > buttonY and y < buttonY + buttonWidth then
                cells = {}
                has_clicked_mine = false
                mine_positions = {}
                mines = math.max(1, math.floor(grid_size * difficulty))
                non_mines = grid_size - mines
                is_game_menu_open = false
                generateGame()
            end
        else
            if button == 1 then
                openCell(x, y)
            elseif button == 2 then
                flagCell(x, y)
            end
        end

    end

    return self
end

return Minesweeper
