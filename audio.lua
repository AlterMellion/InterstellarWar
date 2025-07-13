local audio = {}

local hurtSound

function audio.load()
    hurtSound = love.audio.newSource("audio/hitHurt.wav", "static")
end

function audio.playHurtSound()
    hurtSound:play()
end

return audio