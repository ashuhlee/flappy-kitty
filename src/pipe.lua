
---@class Pipe
Pipe = {}

local pipeDownImg
local pipeUpImg

function Pipe:load()
    pipeDownImg = love.graphics.newImage('assets/pipe_down.png')
    pipeUpImg = love.graphics.newImage('assets/pipe_up.png')

    -- variable setup
    self.width = pipeDownImg:getWidth()

    self.topHeight = pipeDownImg:getHeight()
    self.bottomHeight = pipeUpImg:getHeight()

    self.gap = 230
    self.scored = false
    self.velocity = -1.2

    self:reset()
end

-- dt: delta time
function Pipe:update(dt)
    self.x = self.x + self.velocity

    if (self.x < - self.width) then
        self:respawn()
    end
end

function Pipe:draw()
    love.graphics.draw(pipeDownImg, self.x, self.y - self.topHeight)
    love.graphics.draw(pipeUpImg, self.x, self.y + self.gap)
end

function Pipe:respawn()
    self.x = love.graphics.getWidth()
    self.y = love.math.random(30, 280)
    self.gap = 230
    self.scored = false
end

function Pipe:reset()
    self.x = love.graphics.getWidth() + 200
    self.y = love.math.random(30, 280)
    self.scored = false
end