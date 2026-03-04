
local color = require('util/convertcolor')

function drawTextOutline(fontType, text, strokeClr, textClr, x, y, width, align, size)

    love.graphics.setFont(fontType)

    -- outline
    love.graphics.setColor(color.hex(strokeClr))
    love.graphics.printf(text, x - size, y, width, align)
    love.graphics.printf(text, x + size, y, width, align)
    love.graphics.printf(text, x, y - size, width, align)
    love.graphics.printf(text, x, y + size, width, align)

    -- main text
    love.graphics.setColor(color.hex(textClr))
    love.graphics.printf(text, x, y, width, align)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(mainFont)
end