local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:infestation3PlayerUpdate(player, data, saveData)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.INFESTATION_3) then
        local data = mod:GetEntityData(player)
        local saveData = data.ffsavedata
        --if mod.IsActiveRoom() then
            local roomFrame = game:GetRoom():GetFrameCount()
            if roomFrame == 0 then
                data.infestation3LastPos = nil
            end
            saveData.Infestation3Counter = saveData.Infestation3Counter or 0
            data.infestation3LastPos = data.infestation3LastPos or player.Position
            local dist = player.Position:Distance(data.infestation3LastPos)
            saveData.Infestation3Counter = saveData.Infestation3Counter + dist
            if saveData.Infestation3Counter > (1000 / player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.INFESTATION_3)) then
                if mod.GetEntityCount(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ) < 15 then
                    saveData.Infestation3Counter = 0
                    sfx:Play(SoundEffect.SOUND_SKIN_PULL, 0.5, 0, false, math.random(160,200)/100)
                    local randVec = RandomVector():Resized(math.random(3,10)):Rotated(-45 + math.random(90))
                    local skuzz = Isaac.Spawn(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, 0, player.Position - randVec, Vector.Zero, player):ToFamiliar()
                    skuzz:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    skuzz:Update()
                end
            end
            data.infestation3LastPos = player.Position
        --end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.INFESTATION_3, mod.infestation3PlayerUpdate)
