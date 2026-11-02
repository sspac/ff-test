--TODO: adjust drop rates?
--      maybe it should spawn more "evil" trinkets instead of just the left hand
--      add more tortunes? remove some?
--      what happens if none of the reverse tarot cards are unlocked yet

--torture cookie >:)
local mod = FiendFolio
local game = Game()

local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot, customvardata)
    if player:TakeDamage(1, (DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IV_BAG), EntityRef(player), 0) then

        Isaac.Spawn(1000, 2, 0, player.Position, Vector.Zero, player)

        local r = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.TORTURE_COOKIE)

        local chance = r:RandomInt(100) + 1
        local hud = game:GetHUD()

        local room = game:GetRoom()
        local pos = room:FindFreePickupSpawnPosition(player.Position, 40, true)

        sfx:Play(SoundEffect.SOUND_FORTUNE_COOKIE)

        if chance < 3 then
            Isaac.Spawn(5, 350, mod.GetItemFromCustomItemPool(mod.CustomPool.TORTURE_COOKIE_TRINKETS, r), pos, Vector.Zero, nil) --evil trinket
        elseif chance < 17 then
            Isaac.Spawn(5, 309, 0, pos, Vector.Zero, nil) --reverse tarot card
        elseif chance < 33 then
            Isaac.Spawn(5, 10, 6, pos, Vector.Zero, nil) --black heart
        else
            --[[local fortune = mod.evilFortunes[math.random(1, #mod.evilFortunes)]
            mod.NextFortuneGFX = "gfx/ui/fortune_paper_tortune.png"
            hud:ShowFortuneText(table.unpack(fortune)) --theres a lot to unpack here]]
            mod:ShowTortune()
            if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
                mod:GetEntityData(player).theShampooBottleRespondToTortureCookie = 40 + (math.min(#fortune, 3) * 20)
            end
        end

        return true
    end
end, mod.ITEM.COLLECTIBLE.TORTURE_COOKIE)