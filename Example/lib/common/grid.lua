Grid = Object:extend()

---constructor
---@param x number
---@param y number
---@param resolution number
---@param item_size number
function Grid:new(x, y, resolution, item_size)
    local grid = {}

    setmetatable(grid, self);

    grid.x = x or 0
    grid.y = y or 0
    grid.resolution = resolution or 0
    grid.item_size = item_size or 0
    grid.cells = {}
    for i = 1, resolution do
        grid.cells[i] = {}
        local startX = x + ((i - 1) * item_size)

        for j = 1, resolution do
            local startY = y + ((j - 1) * item_size)

            grid.cells[i][j] = Item:new(startX, startY, item_size, 0)
        end
    end

    return grid
end

function Grid:draw()
    for i = 1, self.resolution do
        for j = 1, self.resolution do
            local item = self.cells[i][j]
            item:draw();
        end
    end
end

function Grid:update(dt)
    for i = 1, self.resolution do
        for j = 1, self.resolution do
            local item = self.cells[i][j]
            item:update(dt);
        end
    end
end

function Grid:toggleCell(x, y)
    local i = math.floor(x / self.item_size) + 1
    local j = math.floor(y / self.item_size) + 1
    if i <= self.resolution and j <= self.resolution then
        if self.cells[i][j].value < 1 then
            self.cells[i][j].value = 1
        else
            self.cells[i][j].value = 0
        end
    end
end


