SoundManager = class("SoundManager")

function SoundManager:ctor( ... )
    self.bg_music_ = 1
end

function SoundManager:PlayBackMusic( )
    AudioEngine.stopMusic()
    self.bg_music_ = self.bg_music_ + 1
    if self.bg_music_ > 4 then self.bg_music_= 1 end
    local path = string.format("buyu1/res/sounds/bgm/bgm%d.mp3", self.bg_music_)
    AudioEngine.playMusic(path, true)
end

function SoundManager:StopBackMusic( )
    AudioEngine.stopMusic()
end

--[[
enum GameEffect
{
    CANNON_SWITCH = 0,
    CASTING,
    CATCH,
    FIRE,
    SUPERARM,
    BINGO,
    WAVE,
};
]]
function SoundManager:PlayGameEffect( game_effect )
    local path
    if game_effect == 0 then
        path = "buyu1/res/sounds/effect/cannonSwitch.wav"
    elseif game_effect == 1 then
        path = "buyu1/res/sounds/effect/casting.wav"
    elseif game_effect == 2 then
        path = "buyu1/res/sounds/effect/catch.wav"
    elseif game_effect == 3 then
        path = "buyu1/res/sounds/effect/fire.wav"
    elseif game_effect == 4 then
        path = "buyu1/res/sounds/effect/superarm.wav"
    elseif game_effect == 5 then
        path = "buyu1/res/sounds/effect/bingo.wav"
    elseif game_effect == 6 then
        path = "buyu1/res/sounds/effect/wave.wav"
    end
    AudioEngine.playEffect(path)
end

function SoundManager:PlayFishEffect( fish_kind )
    if fish_kind >= 11 and fish_kind <= 16 then
        local path
        if fish_kind == 16 then
            path = string.format("buyu1/res/sounds/effect/fish%d_%d.wav", fish_kind+1, math.random(0, 65535)%3 + 1)
        else
            path = string.format("buyu1/res/sounds/effect/fish%d_%d.wav", fish_kind+1, math.random(0, 65535)%2 + 1)
        end
        AudioEngine.playEffect(path)
    end
end

