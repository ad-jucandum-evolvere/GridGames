if arg[#arg] == "debug" then
    require("lldebugger").start()
end

function love.load()
    Object = require("lib.vendor.classic")
    require("lib.common.container")
    require("lib.entities.player")

    love.window.setTitle("Example")

    containers = {}
    count = 5;

    for i = 1, count do
        containers[i] = Container:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 20, 20, i * 25)
    end
end

function love.update(dt)
    for i = 1, #containers do
        containers[i]:update(dt)
    end
end

function love.draw()
    for i = 1, #containers do
        containers[i]:draw()
    end
end

function love.keypressed(key)
    for i = 1, #containers do
        containers[i]:keypressed(key)
    end
end
