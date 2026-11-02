local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.RUNIC_FOSSIL) then
		local mult = math.max(1,math.floor(mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.RUNIC_FOSSIL)))

		local itemConfig = Isaac.GetItemConfig():GetCard(card)
        if itemConfig:IsRune() and card ~= Card.RUNE_SHARD then
			sfx:Play(SoundEffect.SOUND_MIRROR_BREAK, 0.25, 0, false, 3)
			for i=1,mult do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.RUNE_SHARD, player.Position, RandomVector()*5, player)
			end
		end
	end
end)