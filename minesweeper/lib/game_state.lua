local state = {}
local game_state = {}

game_state.initState = function(horizontal_cells, vertical_cells, difficulty)
    local grid_size = horizontal_cells * vertical_cells
    local mines = math.min(1, math.floor(grid_size * difficulty))

    state = {
        mines = mines,
        non_mines = grid_size - mines,
        mine_positions = {},
        ---@type Cell[][]
        cells = {},
        has_clicked_mine = false,
        is_game_menu_open = false
    }
end

game_state.setCells = function(cells)
    state.cells = cells
end

game_state.getState = function()
    return state
end

return game_state
