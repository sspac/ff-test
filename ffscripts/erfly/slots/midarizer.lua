local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local BLASPHEMOUS_SHADER_NAME = "shaders/fiendfolio/coloroffset_blasphemous"

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, d, rng = slot:GetSprite(), mod:GetEntityData(slot), slot:GetDropRNG()
	local data = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    if not d.init then
        if slot.SubType == 10 then
            d.state = "finished"
            d.sleepState = "idle"
        else
            d.state = "idle"
        end

        d.NoDestroy = true
        d.Anims = {
            "Idle",
            "Goldify",
            "Fallasleep",
            "Sleep",
            "NoGoAway",
        }
        d.init = true
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
    elseif d.state == "goldify" then
        if sprite:IsFinished("Goldify") then
            if rng:RandomInt(2) == 1 then
                d.state = "finished"
            else
                d.state = "idle"
            end
        elseif sprite:IsEventTriggered("Goldify") then
            sfx:Play(mod.Sounds.MidarizerGoldify, 1, 0, false, 1)
        elseif sprite:IsEventTriggered("Payout") then
            local trinket = Isaac.Spawn(5, 350, data.StoredTrinket + TrinketType.TRINKET_GOLDEN_FLAG, slot.Position + Vector(0, 25), nilvector, slot)
            if data.StoredTrinketBlasphemous then
                mod:MakePickupTrinketBlasphemous(trinket)
                sprite:GetLayer(2):ClearCustomShader(BLASPHEMOUS_SHADER_NAME)
            end
            sfx:Play(mod.Sounds.MidarizerPayout, 1, 0, false, 1)
        else
            mod:spritePlay(sprite, "Goldify")
        end
    elseif d.state == "finished" then
        slot.SubType = 10
        if not d.sleepState then
            if sprite:IsFinished("Fallasleep") then
                d.sleepState = "idle"
            else
                mod:spritePlay(sprite, "Fallasleep")
            end
        elseif d.sleepState == "idle" then
            mod:spritePlay(sprite, "Sleep")
        elseif d.sleepState == "goaway" then
            if sprite:IsFinished("NoGoAway") then
                d.sleepState = "idle"
            else
                mod:spritePlay(sprite, "NoGoAway")
            end
        end
    end

    FiendFolio.StopExplosionHack(slot)
end, mod.FF.Midarizer.Var)

FiendFolio.onMachineTouch(mod.FF.Midarizer.Var, function(player, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local data = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    if d.state == "idle" then
        local trinket, playerslot, isBlasphemous = FiendFolio.GetMostRecentRockTrinket(player, true, true)
        if trinket > 0 then
            if player:GetNumCoins() >= 10 then
                --print(trinket)
                data.StoredTrinket = trinket
                data.StoredTrinketBlasphemous = isBlasphemous
                data.StoredPlayer = player
                player:TryRemoveTrinket(trinket)
                player:AddCoins(-10)

                sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
                local ItemConfig = Isaac.GetItemConfig()
                sprite:ReplaceSpritesheet(2, ItemConfig:GetTrinket(trinket).GfxFileName)
                sprite:LoadGraphics()
                if isBlasphemous then
                    sprite:GetLayer(2):SetCustomShader(BLASPHEMOUS_SHADER_NAME)
                end
                d.state = "goldify"
            end
        end
    elseif d.sleepState == "idle" then
        d.sleepState = "goaway"
    end
end)