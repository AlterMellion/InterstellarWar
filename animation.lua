local animation = {}

function animation.play(animation, x, y, ox, oy, scale, rotation)
    scale = scale or 1
    rotation = rotation or 0
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    if animation.quads[spriteNum] ~= nil then
        love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], x, y, math.rad(rotation), scale, scale, ox, oy)
    end
end

function animation.new(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0
    return animation
end

function animation.update(animation, dt)
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end
end

return animation