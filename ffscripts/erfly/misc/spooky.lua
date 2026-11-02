local mod = FiendFolio
local game = Game()
local rng = RNG()
local sfx = SFXManager()

local forceHalloweenMode = false
mod.SpookingOfIsaacActivated = nil

local ValueToOffset = {
    [0] = Vector(-32,0),
    [1] = Vector.Zero,
    [2] = Vector(-32,32),
    [3] = Vector(0,32),
}

function mod:spookingGaper(npc)
    if mod.SpookingOfIsaacActivated then
        if npc.Variant == 1 and npc.SubType == 0 then
            local sprite = npc:GetSprite()
            npc:ReplaceSpritesheet(1, "gfx/secret/spooking/pumpkin_gaper.png", true)
            sprite:SetOverlayFrame("Head", 0)
            local layer = sprite:GetLayer(1)
            if layer then
                local d = mod:GetEntityData(npc)
                d.SpookingOfIsaacPumpkinValue = d.SpookingOfIsaacPumpkinValue or npc:GetDropRNG():RandomInt(4)
                layer:SetCropOffset(ValueToOffset[d.SpookingOfIsaacPumpkinValue])
            end
        end
    end
end
mod:AddManualCallback(ModCallbacks.MC_NPC_UPDATE, mod.spookingGaper, EntityType.ENTITY_GAPER)
mod:DisableManualCallback(ModCallbacks.MC_NPC_UPDATE, mod.spookingGaper)

local spookyCoins = {
    [CoinSubType.COIN_PENNY]        = "candy_coin.png",
    [CoinSubType.COIN_NICKEL]       = "candy_nickel.png",
    [CoinSubType.COIN_DIME]         = "candy_dime.png",
    [CoinSubType.COIN_DOUBLEPACK]   = "candy_coin_double.png",
    [CoinSubType.COIN_LUCKYPENNY]   = "candy_coin_lucky.png",
    [CoinSubType.COIN_STICKYNICKEL] = "candy_nickel.png",
    [CoinSubType.COIN_GOLDEN]       = "candy_coin_golden.png",
    [mod.PICKUP.COIN.CURSED]        = "candy_coin_imp.png",
    [mod.PICKUP.COIN.HAUNTED]       = "candy_haunted.png",
    [mod.PICKUP.COIN.GOLDENCURSED]  = "candy_coin_golden_imp.png",
    [mod.PICKUP.COIN.PENNY_THAT_DOUBLES_IN_SIZE_EVERY_DAY]  = "candy_coin.png",
    [mod.PICKUP.COIN.MOBILE_PENNY]  = "candy_coin.png",
}

function mod:spookingCandy(pickup)
    if mod.SpookingOfIsaacActivated then
        if pickup.FrameCount == 1 and spookyCoins[pickup.SubType] and not mod:GetEntityData(pickup).ReplacedByVeil then
            local sprite = pickup:GetSprite()
            sprite:ReplaceSpritesheet(0, "gfx/secret/spooking/" .. spookyCoins[pickup.SubType], true)
        end
    end
end
mod:AddManualCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.spookingCandy, PickupVariant.PICKUP_COIN)
mod:DisableManualCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.spookingCandy)

function mod:spookingSoundReplacement(sound, volume, delay, loop, pitch, pan)
    if mod.SpookingOfIsaacActivated then
        if math.random(10) == 1 then
            sfx:Play(mod.Sounds.SpookingOfIsaacGaper, volume * 0.75, delay, loop, pitch * (math.random(80,120)/100), pan)
        end
        return false
    end
end
mod:AddEntityCallback(ModCallbacks.MC_PRE_SFX_PLAY, EntityType.ENTITY_GAPER, 1, 0, mod.spookingSoundReplacement, SoundEffect.SOUND_ZOMBIE_WALKER_KID)

local pennySounds = {
    [SoundEffect.SOUND_PENNYPICKUP] = true,
    [SoundEffect.SOUND_NICKELPICKUP] = true,
    [SoundEffect.SOUND_DIMEPICKUP] = true,
    [SoundEffect.SOUND_LUCKYPICKUP] = true,
    [mod.Sounds.CursedPennyNeutral] = true,
    [mod.Sounds.CursedPennyPositive] = true,
    [mod.Sounds.CursedPennyPositiveSuper] = true,
    [mod.Sounds.CursedPennyPositiveMega] = true,
    [mod.Sounds.CursedPennyNegative] = true,
    [mod.Sounds.CursedPennyNegativeSuper] = true,
    [mod.Sounds.CursedPennyNegativeMega] = true,
}

function mod:spookingCandySoundReplacement(sound, volume, delay, loop, pitch, pan)
    if mod.SpookingOfIsaacActivated then
        if pennySounds[sound] then
            sfx:Play(mod.Sounds.Monch, 1, 0, false, math.random(75,150)/100)
        end
    end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.spookingCandySoundReplacement)
mod:DisableManualCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.spookingCandySoundReplacement)

do
    local dateTime = os.date("*t")
    if (dateTime.day == 31 and dateTime.month == 10)
    or forceHalloweenMode then
        mod.SpookingOfIsaacActivated = true
        mod:EnableManualCallback(ModCallbacks.MC_NPC_UPDATE, mod.spookingGaper)
        mod:EnableManualCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.spookingCandy)
        mod:EnableManualCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.spookingCandySoundReplacement)
    end
end