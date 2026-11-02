local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

FiendFolio.AddItemPickupCallback(function(player, added)
	player:AddRottenHearts(2)
end, nil, mod.ITEM.COLLECTIBLE.FRAUDULENT_FUNGUS)

function mod:FradulentFungusSound(pickup, collider)
    local player = collider:ToPlayer()
    if (
        player
        and pickup.SubType == mod.ITEM.COLLECTIBLE.FRAUDULENT_FUNGUS 
        and not pickup.Touched 
        and pickup.Wait == 0
        and (
			not pickup:IsShopItem()
			or mod.WillPlayerBuyPickup(player, pickup)
		)
        and player:IsExtraAnimationFinished()
        and player:CanPickupItem()
        and player:GetPlayerType() ~= PlayerType.PLAYER_CAIN_B
    ) then
        sfx:Play(mod.Sounds.FraudulentFungusPickup, 2, 0, false, 1)
        Isaac.CreateTimer(function ()
            sfx:Stop(SoundEffect.SOUND_CHOIR_UNLOCK)
        end, 1, 1, true)
    end
end
mod:AddEntityCallback(
    ModCallbacks.MC_PRE_PICKUP_COLLISION,
    EntityType.ENTITY_PICKUP,
    PickupVariant.PICKUP_COLLECTIBLE,
    mod.ITEM.COLLECTIBLE.FRAUDULENT_FUNGUS,
    mod.FradulentFungusSound,
    PickupVariant.PICKUP_COLLECTIBLE
)