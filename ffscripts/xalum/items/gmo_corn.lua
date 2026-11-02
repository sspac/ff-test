local mod = FiendFolio
local game = Game()
local nilvector = mod.nilvector

local function getRandomGMOCornPill(player)
	local GoodPill = (player:HasCollectible(CollectibleType.COLLECTIBLE_PHD) or player:HasCollectible(CollectibleType.COLLECTIBLE_VIRGO) or player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT))
	local BadPill = player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD)
	if GoodPill and BadPill then
		GoodPill = nil
		BadPill = nil
	end
	local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GMO_CORN)
	local itemConfig = Isaac.GetItemConfig()
	local pill
	local pillValid
	while (not pillValid) do
		pill = rng:RandomInt(PillEffect.NUM_PILL_EFFECTS)
		local pillConfig = itemConfig:GetPillEffect(pill)
		if pillConfig:IsAvailable() then
			pillValid = true
			if pillConfig.EffectSubClass == 2 and GoodPill then
				pillValid = false
			elseif pillConfig.EffectSubClass == 1 and BadPill then
				pillValid = false
			elseif player:GetHearts() <= 2 then
				if pill == PillEffect.PILLEFFECT_FULL_HEALTH
				or pill == PillEffect.PILLEFFECT_HEALTH_DOWN
				then
					pillValid = false
				end
			end
		end
	end
	return pill
end

function FiendFolio.QueuePills(player, num)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata
	data.pilltimer = 0
	sdata.pillstotake = sdata.pillstotake + num
end

function mod:TakeQueuedPills(player, data, sdata)
	if sdata.pillstotake > 0 then
		if not data.pilltimer then data.pilltimer = 0 end
		if data.pilltimer == 0 and data.gmofrozen then
			player:AnimateHappy()
		end
		data.pilltimer = data.pilltimer + 1
		if data.pilltimer % 15 == 0 then
			if data.queuedSpecificPills then
				player:UsePill(data.queuedSpecificPills[1], math.random(PillColor.NUM_PILLS - 1))
				table.remove(data.queuedSpecificPills, 1)
				if #data.queuedSpecificPills == 0 then
					data.queuedSpecificPills = nil
				end
			else
				local pill = getRandomGMOCornPill(player)
				player:UsePill(pill, math.random(PillColor.NUM_PILLS - 1))
				sdata.pillstotake = sdata.pillstotake - 1
				player:AddCacheFlags(CacheFlag.CACHE_ALL)
				player:EvaluateItems()
			end
		end
	elseif data.gmofrozen then
		data.gmofrozen = false
		player.ControlsEnabled = true
	end
end

FiendFolio.AddItemPickupCallback(function(player, added)
	local pillcount = player:HasCollectible(CollectibleType.COLLECTIBLE_LITTLE_BAGGY) and 10 or 7
	FiendFolio.QueuePills(player, added * pillcount)
	player.ControlsEnabled = false
	mod:GetEntityData(player).gmofrozen = true
end, nil, mod.ITEM.COLLECTIBLE.GMO_CORN)