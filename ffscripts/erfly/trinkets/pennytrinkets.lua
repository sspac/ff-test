local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local isCursedPenny = {
    [FiendFolio.PICKUP.COIN.CURSED] = true,
    [FiendFolio.PICKUP.COIN.GOLDENCURSED] = true,
    [FiendFolio.PICKUP.COIN.MEDLEY] = true,
}

function mod:pennyPickupFlaming(pickup, player, value)
    if player:HasTrinket(mod.ITEM.TRINKET.FLAMING_PENNY) then
        --local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.PENNY_PACK)
        --if rng:RandomFloat() < 1 - (5/6) ^ value then
        for i = 1, player:GetTrinketMultiplier(mod.ITEM.TRINKET.FLAMING_PENNY) do
            local data = mod:GetEntityData(player)
            local sdata = data.ffsavedata
            if sdata.orbitingfireballs and sdata.orbitingfireballs < mod:GetFireballCap(player) + 3 then
                local fiendflasheffect = Isaac.Spawn(1000, 668, 0, player.Position, Vector(0,0), player):ToEffect()
                mod:GetEntityData(fiendflasheffect).parent = player
                if mod:isSuperpositionedPlayer(player) then
                    local flashcolor = Color.Lerp(fiendflasheffect.Color, Color(1,1,1,1,0,0,0), 0)
                    flashcolor.A = flashcolor.A / 4
                    fiendflasheffect.Color = flashcolor
                end
                sfx:Play(SoundEffect.SOUND_FLAME_BURST, 0.3, 0, false, math.random(150,160)/100)

                sdata.orbitingfireballs = sdata.orbitingfireballs + 1
                if isCursedPenny[pickup.SubType] then
                    data.nextFireballShouldBeFiendish = true
                end
                player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
                player:EvaluateItems()
            end
        end
        --end
    end
end

function mod:pennyPickupPennyPack(pickup, player, value)
    if player:HasTrinket(mod.ITEM.TRINKET.PENNY_PACK) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.PENNY_PACK)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.PENNY_PACK)
        local chance = value * mult

        local basedata = mod:GetEntityData(player)
        local savedata = basedata.ffsavedata
        if savedata then
            savedata.PennyPackPayouts = savedata.PennyPackPayouts or 0
            chance = chance / (savedata.PennyPackPayouts + 1)
        end
        if rng:RandomFloat() < 1 - (11/12) ^ chance then
            local trinket = mod.ITEM.TRINKET.PENNY_PACK
            while trinket == mod.ITEM.TRINKET.PENNY_PACK do
                trinket = mod:GetPennyTrinketIncludingFunnies(rng)
                --trinket = mod.GetItemFromCustomItemPool(mod.CustomPool.PENNY_TRINKETS, rng)
            end
            Isaac.Spawn(5, 350, trinket, pickup.Position, Vector.Zero, nil)
            if savedata then
                savedata.PennyPackPayouts = savedata.PennyPackPayouts + 1
            end
        end
    end
end