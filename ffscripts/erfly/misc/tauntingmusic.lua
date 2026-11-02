local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

--[[
function mod:checkDidPlayerDieForFunny(player, data)
    if player:IsDead() then
        if not data.checkedMusicForFunnyDHGameOver then
            if math.random(200) == 1 then
                mod.scheduleForUpdate(function()
                    local ms = MusicManager()
                    if ms:GetCurrentMusicID() == Music.MUSIC_JINGLE_GAME_OVER then
                        ms:Play(mod.Music.DevilsHarvestGameOver, 0)
                        ms:UpdateVolume()
                    end
                end, 120, ModCallbacks.MC_POST_RENDER)
            end
            data.checkedMusicForFunnyDHGameOver = true
        end
    elseif data.checkedMusicForFunnyDHGameOver then
        data.checkedMusicForFunnyDHGameOver = false
    end
end
]]

mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, function(_, music, volume)
    local player = Isaac.GetPlayer()
    if (not player or player:IsDead()) and math.random(200) == 1 then
        return mod.Music.DevilsHarvestGameOver
    end
end, Music.MUSIC_JINGLE_GAME_OVER)
