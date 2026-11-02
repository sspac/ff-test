local mod = FiendFolio
local game = Game()

mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.TRINKET.RED_RIBBON, function(_, player)
	local numRedRibbon = mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.RED_RIBBON)
	if numRedRibbon > 0 then
		if player:GetEternalHearts() == 1 then
			if numRedRibbon > 1 then
				player:AddEternalHearts(3)
			elseif numRedRibbon == 1 then
				player:AddEternalHearts(1)
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if pickup.SubType == 4 then
		local pd = mod:GetEntityData(pickup)
		if mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.RED_RIBBON) > 1 then
			local sprite = pickup:GetSprite()
			if sprite:IsPlaying("Idle") or sprite:IsPlaying("Appear") then
				if pd.isFullFromRR ~= 2 then
					sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/full_eternal_heart_2.png")
					sprite:LoadGraphics()

					if (not sprite:IsPlaying("Appear")) and pickup.FrameCount > 0 then
						local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 15, pickup.Position, nilvector, nil)
						poof.Color = Color(5,5,5,1,0,0,0)
						poof:Update()
					end

					pd.isFullFromRR = 2
				end
			end
		elseif mod.anyPlayerHas(mod.ITEM.TRINKET.RED_RIBBON, true) then
			local sprite = pickup:GetSprite()
			if sprite:IsPlaying("Idle") or sprite:IsPlaying("Appear") then
				if pd.isFullFromRR ~= 1 then
					sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/full_eternal_heart.png")
					sprite:LoadGraphics()

					if (not sprite:IsPlaying("Appear")) and pickup.FrameCount > 0 then
						local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 15, pickup.Position, nilvector, nil)
						poof.Color = Color(5,5,5,1,0,0,0)
						poof:Update()
					end

					pd.isFullFromRR = 1
				end
			end
		else
			if pd.isFullFromRR then
				local sprite = pickup:GetSprite()
				sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/pickup_001_heart.png")
				sprite:LoadGraphics()
				if (sprite:IsPlaying("Idle") or sprite:IsPlaying("Appear")) and pickup.FrameCount > 0 then
					local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 15, pickup.Position, nilvector, nil)
					poof.Color = Color(5,5,5,1,0,0,0)
					poof:Update()
				end

				pd.isFullFromRR = false
			end
		end
	end
end, 10)