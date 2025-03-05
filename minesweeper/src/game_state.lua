Game = Object:extend()

function Game:new()
    local game = {}

    setmetatable(game, self)

    game.state = {}
    game.state.cell_size = 50
    game.state.board_resolution = love.graphics.getHeight() / game.state.cell_size
    game.state.isPaused = false
    game.state.cells = {}
    for i = 1, game.state.board_resolution do
        game.state.cells[i] = {}
        local x = ((i - 1) * game.state.cell_size)

        for j = 1, game.state.board_resolution do
            local y = ((j - 1) * game.state.cell_size)

            game.state.cells[i][j] = Cell:new(x, y, game.state.cell_size, 0)
        end
    end

    return game;
end

function Game:draw()
    for i = 1, self.state.board_resolution do
        for j = 1, self.state.board_resolution do
            local cell = self.state.cells[i][j]
            cell:draw();
        end
    end
end

function Game:update(dt)
    for i = 1, self.state.board_resolution do
        for j = 1, self.state.board_resolution do
            local cell = self.state.cells[i][j]
            cell:update();
        end
    end
end

function Game:updateCell(x, y)
    local i = math.floor(x / self.state.cell_size) + 1
    local j = math.floor(y / self.state.cell_size) + 1
    if i <= self.state.board_resolution and j <= self.state.board_resolution then
        if self.state.cells[i][j].value < 1 then
            self.state.cells[i][j].value = 1
        else
            self.state.cells[i][j].value = 0
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        game:updateCell(x, y)
    end
end



