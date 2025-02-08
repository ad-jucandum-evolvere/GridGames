Player = Object:extend()

---constructor
---@param x number
---@param y number
---@param width number
---@param height number
function Player:new(x, y, width, height, offset)
    local player = {}

    setmetatable(player, self);

    player.x = x or 0
    player.y = y or 0
    player.width = width or 10
    player.height = height or 10
    player.direction = offset / 25
    player.speed = 20 * (offset / 25)
    player.semiWidth = player.width / 2
    player.semiHeight = player.height / 2
    player.colorRadians = 0
    player.offset = offset

    return player
end

function Player:update(dt)
    if self.direction == 1 then
        self.x = self.x - self.speed * dt
    elseif self.direction == 2 then
        self.y = self.y - self.speed * dt
    elseif self.direction == 3 then
        self.x = self.x + self.speed * dt
    elseif self.direction == 4 then
        self.y = self.y + self.speed * dt
    end

    -- handle warping
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    if self.x + self.semiWidth <= 0 then
        self.x = screenWidth + self.semiWidth
    elseif self.x - self.semiWidth >= screenWidth then
        self.x = -self.semiWidth
    end
    if self.y + self.semiHeight <= 0 then
        self.y = screenHeight + self.semiHeight
    elseif self.y - self.semiHeight >= screenHeight then
        self.y = -self.semiHeight
    end
    self.colorRadians = self.colorRadians + 0.1
end

function Player:draw()
    local left = self.x - self.semiWidth + self.offset
    local top = self.y - self.semiHeight + self.offset

    local red = 1 + math.sin(self.colorRadians + math.pi / 2)
    local green = 1 + math.sin(self.colorRadians + math.pi)
    local blue = 1 + math.sin(self.colorRadians)

    love.graphics.setColor(red, green, blue)
    love.graphics.rectangle("fill", left, top, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end

function Player:handleKeyPress(key)
    if key == "escape" then love.event.quit(0) end
    if key == "up" or key == "left" then
        self.direction = self.direction - 1
        if self.direction == 0 then self.direction = 4 end
    elseif key == "down" or key == "right" then
        self.direction = self.direction + 1
        if self.direction == 5 then self.direction = 1 end
    end
end
