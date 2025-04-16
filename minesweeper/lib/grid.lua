local readonly = require("lib.readonly")
local grid = {}

---@param horizontal_cells number
---@return number
grid.getHorizontalSize = function(horizontal_cells)
    return math.max(3, math.min(horizontal_cells, 25))
end

---@param vertical_cells number
---@return number
grid.getVerticalSize = function(vertical_cells)
    return math.max(3, math.min(vertical_cells, 15))
end

---@param difficulty string
---@return number
grid.calculateGridDifficulty = function(difficulty)
    return (difficulty == "medium" and 0.15) or (difficulty == "easy" and 0.1) or 0.2
end

return grid
