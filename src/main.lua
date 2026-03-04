
require('player')
require('pipe')

require('util/style')
local color = require('util/convertcolor')

mainFont = love.graphics.newFont('assets/digital_disco.ttf', 60)
mediumFont = love.graphics.newFont('assets/digital_disco.ttf', 40)
smallFont = love.graphics.newFont('assets/digital_disco.ttf', 25)


function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(mainFont)

    bgMusic = love.audio.newSource('assets/bg_music.mp3', 'stream')
    bgMusic:setVolume(0.2)
    bgMusic:setLooping(true)

    slapSfx = love.audio.newSource('assets/slap.mp3', 'static')
    scoreSfx = love.audio.newSource('assets/score.mp3', 'static')

    meowSfx = love.audio.newSource('assets/meow.mp3', 'static')
    meowSfx:setVolume(0.1)

    bgImg = love.graphics.newImage('assets/background.png')

    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()

    bgScaleX = windowWidth / bgImg:getWidth()
    bgScaleY = windowHeight / bgImg:getHeight()

    floorImg = love.graphics.newImage('assets/ground.png')
    floorWidth = floorImg:getWidth()
    floorY = windowHeight - floorImg:getHeight()

    Player:load()
    Pipe:load()

    love.audio.play(bgMusic)

    -- variable setup
    score = 0
    hasMoved = false
    isGameOver = false

    bgXPos = 0
    floorXPos = 0

    bgScrollSpeed = 0.5
    floorScrollSpeed = 1

end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return (
        x1 < (x2 + w2) and
        x2 < (x1 + w1) and
        y1 < (y2 + h2) and
        y2 < (y1 + h1)
    )
end

function love.update(dt)
    -- bg and ground scrolling
    bgXPos = bgXPos - bgScrollSpeed
    floorXPos = floorXPos - floorScrollSpeed

    -- reset bg and ground pos
    if (bgXPos <= -windowWidth) then
        bgXPos = 0
    end

    if (floorXPos <= -floorWidth) then
        floorXPos = 0
    end

    -- reset player if too high or low
    local px, py, pw, ph = Player:getHitbox()

    if (py < 0) or ((py + ph) > floorY) then
        gameOver()
    end

    if (hasMoved == true) then
        Player:update(dt)
        Pipe:update(dt)
    end

    -- check if player is touching pipe
    local px, py, pw, ph = Player:getHitbox()

    if checkCollision(px, py, pw, ph, Pipe.x, Pipe.y - Pipe.topHeight, Pipe.width, Pipe.topHeight) or
       checkCollision(px, py, pw, ph, Pipe.x, Pipe.y + Pipe.gap, Pipe.width, Pipe.bottomHeight) then
           gameOver()
    end

    if not Pipe.scored and (Player.x > Pipe.x) then
        score = score + 1
        love.audio.play(scoreSfx)
        Pipe.scored = true
    end
end

function love.keypressed(key, scancode, isrepeat)

    if isGameOver and key == 'return' then
        restartGame()
        return
    end

    if isGameOver then
        return
    end

    if (hasMoved == false) then
        hasMoved = true
    end

    if (key == 'space') then
        Player:jump()
    end
end

function gameOver()

    if isGameOver then
        return
    end

    Player:setDead(true)

    hasMoved = false
    isGameOver = true

    love.audio.play(slapSfx)
    love.audio.play(meowSfx)

    love.audio.stop(bgMusic)
end

function restartGame()

    Player:reset()
    Pipe:reset()

    score = 0
    hasMoved = false
    isGameOver = false

    love.audio.play(bgMusic)
end

function love.draw()
    love.graphics.draw(bgImg, bgXPos, 0, 0, bgScaleX, bgScaleY)
    love.graphics.draw(bgImg, bgXPos + windowWidth, 0, 0, bgScaleX, bgScaleY)

    love.graphics.draw(floorImg, floorXPos, floorY)
    love.graphics.draw(floorImg, floorXPos + floorWidth, floorY)

    Player:draw()
    Pipe:draw()

    -- display score
    love.graphics.setColor(1, 1, 1)
    -- shadow
    drawTextOutline(mainFont, score,'#C59FFD', '#C59FFD', 13, 33, windowWidth, 'center', 5)
    drawTextOutline(mainFont, score,'#4A4B75', '#FAFAFF', 10, 30, windowWidth, 'center', 5)

    -- display game over
    if isGameOver then
        -- shadow
        drawTextOutline(mediumFont, string.upper('game over!'), '#626396', '#626396', 3, 223, windowWidth, 'center', 4)
        drawTextOutline(mediumFont, string.upper('game over!'), '#ffffff', '#ed5f90', 0, 220, windowWidth, 'center', 4)

        love.graphics.setFont(smallFont)
        -- shadow
        love.graphics.setColor(color.hex('#535480'))
        love.graphics.printf('press enter to restart', 2, 272, windowWidth, 'center')
        -- main text
        love.graphics.setColor(color.hex('#ffffff'))
        love.graphics.printf('press enter to restart', 0, 270, windowWidth, 'center')

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(mainFont)
    end
end
