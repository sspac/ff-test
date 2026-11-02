local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local sounds = {
	SoundEffect.SOUND_SMB_LARGE_CHEWS_4,
	SoundEffect.SOUND_VAMP_GULP
}

mod:AddChallengeCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.challenges.allYouCanEat, function(_, player)
	local hud = game:GetHUD()
	local configItem = Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.PAK_CHOI)

	Isaac.CreateTimer(function()
		player:AddCollectible(mod.ITEM.COLLECTIBLE.PAK_CHOI)
		player:AnimateCollectible(mod.ITEM.COLLECTIBLE.PAK_CHOI)
		hud:ShowItemText(player, configItem)
		sfx:Play(sounds[math.random(#sounds)])
	end, 7, 30, true)
end, 0)

mod:AddChallengeCallback(ModCallbacks.MC_POST_UPDATE, mod.challenges.allYouCanEat, function()
	if game:GetDebugFlags() & DebugFlag.HITSPHERES == 0 then
		game:AddDebugFlags(DebugFlag.HITSPHERES)
	end
end)

mod:AddChallengeCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.challenges.allYouCanEat, function(_, pickup)
	if FiendFolio:IsHeartPickup(pickup) then
		pickup:Remove()
	end
end)