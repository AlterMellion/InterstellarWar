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

return helper