
function love.draw()
	love.graphics.print("Flappy Kitty", 100, 100)
end

local r, g, b = love.math.colorFromBytes(255, 204, 236)
love.graphics.setBackgroundColor(r,g,b)