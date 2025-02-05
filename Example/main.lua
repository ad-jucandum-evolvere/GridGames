if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
    Object = require("lib.vendor.classic")
    require("lib.entities.player")

    love.window.setTitle("Example")
    player = Player:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 20, 20)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
end

function love.keypressed(key)
    player:handleKeyPress(key)
end
