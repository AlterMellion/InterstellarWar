local score = {}

function score.load()
    local scoreFont = love.graphics.newFont("fonts/pixelmix.ttf", 35)
    love.graphics.setFont(scoreFont)
    score.value = 0
end

function score.draw()
    love.graphics.print(score.value, 5, 5)
end

function score.update(points)
    score.value = score.value + points
end

return score