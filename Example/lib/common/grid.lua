Grid = Object:extend()

---constructor
---@param x number
---@param y number
---@param grid_resolution number
---@param cell_size number
function Grid:new(x, y, grid_resolution, cell_size)
    local grid = {}

    setmetatable(grid, self);

    grid.x = x or 0
    grid.y = y or 0
    grid.grid_resolution = grid_resolution or 0
    grid.cell_size = cell_size or 0
    grid.cells = {}
    for i = 1, grid_resolution do
        grid.cells[i] = {}
        local startX = x + ((i - 1) * cell_size)

        for j = 1, grid_resolution do
            local startY = y + ((j - 1) * cell_size)

            grid.cells[i][j] = Cell:new(startX, startY, cell_size, 0)
        end
    end

    return grid
end

function Grid:draw()
    for i = 1, self.grid_resolution do
        for j = 1, self.grid_resolution do
            local cell = self.cells[i][j]
            cell:draw();
        end
    end
end

function Grid:update(dt)
    for i = 1, self.grid_resolution do
        for j = 1, self.grid_resolution do
            local cell = self.cells[i][j]
            cell:update(dt);
        end
    end
end

function Grid:toggleCell(x, y)
    local i = math.floor(x / self.cell_size) + 1
    local j = math.floor(y / self.cell_size) + 1
    if i <= self.grid_resolution and j <= self.grid_resolution then
        if self.cells[i][j].value < 1 then
            self.cells[i][j].value = 1
        else
            self.cells[i][j].value = 0
        end
    end
end


