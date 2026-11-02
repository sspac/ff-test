local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local beatFrames = {
    [10] = Vector(98, 102),
    [11] = Vector(99, 101),
}

--It's not perfect but isaac doesn't give me much to work with, sorry music people
local JukeboxTunes = {
    {ID = mod.Music.Saloon, Speed = 17.31},
    {ID = mod.Music.BossTheme, Speed = 14},
    {ID = mod.Music.HorsemanTheme, Speed = 10.1},
    {ID = mod.Music.BlackMarket, Speed = 19.14},
    {ID = mod.Music.AltBossTheme, Speed = 15},
    {ID = mod.Music.MinibossTheme, Speed = 12.27},
    {ID = mod.Music.DrollCall, Speed = 17},
    {ID = mod.Music.PlenaNavitasRemix, Speed = 14.25},
    {ID = mod.Music.PronounPalaceHeadline, Speed = 17.85},
    {ID = mod.Music.DevilsHarvestGameOver, Speed = 12.75},
}

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local data = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    local mus = MusicManager()
    --print(mus:IsEnabled())

    if not d.init then
        slot:SetSize(9, Vector(2,1), 24)
        d.init = true
    end

    if not d.DropFunc then
		function d.DropFunc()
			if not d.DidDropFunc then
                d.DidDropFunc = true
                sfx:Stop(mod.Sounds.JukeboxRoll)
                mod:spritePlay(sprite, "Death")
                sprite:RemoveOverlay()
                slot.SpriteScale = Vector.One
                if mus:IsEnabled() then
                    mus:Disable()
                    mod:EnableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.jukeboxResumeMusic)
                end

                local rng = slot:GetDropRNG()
                local rand = rng:RandomInt(20)
                if rand == 0 then
                    local vec = RandomVector()
                    rand = rng:RandomInt(5)
                    local itemPool = game:GetItemPool()
                    if rand == 0 and itemPool:HasTrinket(mod.ITEM.TRINKET.BROKEN_RECORD) then
                        Isaac.Spawn(5, PickupVariant.PICKUP_TRINKET, mod.ITEM.TRINKET.BROKEN_RECORD, slot.Position + vec, vec:Resized(5), slot)
                        itemPool:RemoveTrinket(mod.ITEM.TRINKET.BROKEN_RECORD)
                    else
                        Isaac.Spawn(5, mod.PICKUP.VARIANT.RANDOM_OBJECT, 1, slot.Position + vec, vec:Resized(5), slot)
                    end
                elseif rand <= 2 then
                    for i = 1, rng:RandomInt(2) + 1 do
                        local vec = RandomVector()
                        Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 0, slot.Position + vec, vec:Resized(5), slot)
                    end
                end
            end
		end
	end

    if d.DidDropFunc then
        if not sprite:IsPlaying("Death") then
            mod:spritePlay(sprite, "Broken")
        end
    else
        if d.state == "Idle" then
            d.waitAFrame = false
            if not mus:IsEnabled() then
                sprite:SetFrame("Idle", 0)
                sprite:RemoveOverlay()
            else
                d.Speed = d.Speed or 17.31
                local calc = slot.FrameCount * (16/d.Speed)
                local frame = math.floor(calc % 16)
                sprite:SetFrame("Idle", frame)
                mod:spriteOverlayPlay(sprite, "Idle Overlay")
                if beatFrames[frame] then
                    slot.SpriteScale = beatFrames[sprite:GetFrame()]/100
                else
                    slot.SpriteScale = Vector.One
                end
            end
        elseif d.state == "Switch" then
            if sprite:IsFinished("Change Song") then
                d.state = "Idle"
                sfx:Stop(mod.Sounds.JukeboxRoll)
                sfx:Play(mod.Sounds.JukeboxRollEnd, 1, 0, false, math.random(90,120)/100)
                --[[local randMus = JukeboxTunes[math.random(#JukeboxTunes)]
                while randMus.ID == d.LastTune do
                    randMus = JukeboxTunes[math.random(#JukeboxTunes)]
                end]]
                --print(randMus.ID, d.LastTune)
                d.CurrentTune = d.CurrentTune or 0
                d.CurrentTune = (d.CurrentTune + 1) % #JukeboxTunes
                local newTune = JukeboxTunes[d.CurrentTune + 1]
                d.Speed = newTune.Speed
                mus:Fadein(newTune.ID, Options.MusicVolume, 0.3)

                mod:DisableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.jukeboxResumeMusic)
                d.waitAFrame = true
            else
                mod:spritePlay(sprite, "Change Song")
            end
        else
            d.state = "Idle"
        end
    end

    FiendFolio.OverrideExplosionHack(slot, true)
end, mod.FF.Jukebox.Var)

FiendFolio.onMachineTouch(mod.FF.Jukebox.Var, function(player, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local data = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    if d.state == "Idle" and not (d.waitAFrame or d.DidDropFunc) then
        d.state = "Switch"
        local mus = MusicManager()
        --d.LastTune = mus:GetCurrentMusicID()
        mus:Fadeout(0.3)
        mod:EnableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.jukeboxResumeMusic)
        sfx:Play(mod.Sounds.JukeboxRoll, 1, 0, false, math.random(90,120)/100)
        sprite:RemoveOverlay()
    end
end)

function mod:jukeboxResumeMusic()
    mod.scheduleForUpdate(function()
        local mus = MusicManager()
        mus:Enable()
        mus:Fadein(mus:GetCurrentMusicID(), Options.MusicVolume, 0.3)
        mod:DisableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.jukeboxResumeMusic)
    end, 3, nil, true)
end
mod:AddManualCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.jukeboxResumeMusic)