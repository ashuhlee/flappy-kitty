
---@class Player
---@field x number
---@field y number
---@field velocity number
Player = {}

local playerAliveImg
local playerDeadImg
local currentPlayerImg
local wooshSfx


function Player:centerOnScreen()

    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    self.x = (windowWidth - self.width) / 2
    self.y = (windowHeight - self.height) / 2
end

-- same as Player.load(self)
function Player:load()
    -- load player assets
    wooshSfx = love.audio.newSource('assets/woosh.mp3', 'static')

    playerAliveImg = love.graphics.newImage('assets/player.png')
    playerAliveImg:setFilter('nearest', 'nearest')

    playerDeadImg = love.graphics.newImage('assets/player_dead.png')
    playerDeadImg:setFilter('nearest', 'nearest')

    currentPlayerImg = playerAliveImg

    -- variable setup
    self.width = currentPlayerImg:getWidth()
    self.height = currentPlayerImg:getHeight()

    -- player position on screen
    self:centerOnScreen()

    self.velocity = 0.0
end

function Player:getHitbox()

    local insLeft = 8
    local insRight = 8

    local insTop = 6
    local insBottom = 4

    local x = self.x + insLeft
    local y = self.y + insTop
    local width = self.width - insLeft - insRight
    local height = self.height - insTop - insBottom

    return x, y, width, height
end

-- dt: delta time
function Player:update(dt)
    self:move(dt)
end

function Player:jump()
    self.velocity = -7

    love.audio.stop(wooshSfx) -- stop previous sfx
    love.audio.play(wooshSfx)
end

function Player:move(dt)
    self.velocity = self.velocity + 0.25
    self.y = self.velocity + self.y
end

function Player:setDead(isDead)
    if isDead then
        currentPlayerImg = playerDeadImg
    else
        currentPlayerImg = playerAliveImg
    end
end

function Player:draw()
    love.graphics.draw(currentPlayerImg, self.x, self.y)
end

function Player:reset()
    Player:setDead(false)
    self:centerOnScreen()
    self.velocity = 0
end