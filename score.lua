local score = {}

function score.load()
    score.value = 0
end

function score.draw()
    love.graphics.print(score.value, 5, 5)
end

function score.update(points)
    score.value = score.value + points
end

function score.getValue()
    return score.value
end

return score