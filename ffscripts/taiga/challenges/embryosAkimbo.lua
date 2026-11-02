-- Embryos Akimbo --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddChallengeCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.challenges.embryosAkimbo, function(_, familiar)
	familiar:Remove()
end, FamiliarVariant.INCUBUS)

mod:AddPriorityChallengeCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, CallbackPriority.EARLY, mod.challenges.embryosAkimbo, function()
	return FollowerPriority.INCUBUS
end, FiendFolio.ITEM.FAMILIAR.LIL_FRIEND)

mod:AddChallengeCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.challenges.embryosAkimbo, function(_, player)
	player:AddBlackHearts(-2)
	player:SetPocketActiveItem(FiendFolio.ITEM.COLLECTIBLE.CHERRY_BOMB)
	
	local itempool = game:GetItemPool()
	itempool:RemoveCollectible(FiendFolio.ITEM.COLLECTIBLE.CHERRY_BOMB)
	itempool:RemoveCollectible(FiendFolio.ITEM.COLLECTIBLE.HOW_TO_ROLL)
	itempool:RemoveCollectible(FiendFolio.ITEM.COLLECTIBLE.LIL_FRIEND)
	itempool:RemoveCollectible(CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION)
	
	player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION))
end)

mod:AddChallengeCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.challenges.embryosAkimbo, function(_, player)
	player:SetCambionConceptionState(0)
end)