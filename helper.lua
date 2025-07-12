local helper={}

function helper.drawCenter(image, x, y)
    love.graphics.draw(image, x, y, 0, 1, 1,
        image:getWidth()/2,
        image:getHeight()/2
    )
end

function helper.distanceBetweenTwoObjects(x1, y1, x2, y2)
    local deltaX = x2 - x1
    local deltaY = y2 - y1

    local deltaXSquare = deltaX ^ 2
    local deltaYSquare = deltaY ^ 2

    local squareSum = deltaXSquare + deltaYSquare

    local distance = squareSum ^ 0.5
    return distance
end

function helper.SplitStringIntoArray(inputstr, sep)
   if sep == nil then
      sep = '\n'
   end

   local t={} 
   for str in string.gmatch(inputstr, '([^'..sep..']+)') 
   do
      table.insert(t, str)
   end

   return t
end

function helper.outlineText(text, x, y)
    love.graphics.setColor(0,0,0)
    love.graphics.printf(text, x, y - 2, ScreenWidth - 2, "center")
    love.graphics.printf(text, x, y + 2, ScreenWidth + 2, "center")

    love.graphics.setColor(1,1,1)
    love.graphics.printf(text, x, y, ScreenWidth, "center")
end

return helper