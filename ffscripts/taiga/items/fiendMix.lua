-- Fiend Mix --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

FiendFolio.FiendMixMinions = {
	["RED_HEART"] = {{ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 7, PickupID = 5, PickupVar = 10, PickupSub = HeartSubType.HEART_HALF, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_red_half.anm2", Dataflags = {{"hollowanim", true}}},
	                 {ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 6, PickupID = 5, PickupVar = 10, PickupSub = HeartSubType.HEART_FULL, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_red.anm2", Dataflags = {}}},
	["ROTTEN_HEART"] = {{ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 8, PickupID = 5, PickupVar = 10, PickupSub = HeartSubType.HEART_ROTTEN, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_rotten.anm2", Dataflags = {{"hollowanim", true}}}},
	["SOUL_HEART"] = {{ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 10, PickupID = 5, PickupVar = 10, PickupSub = HeartSubType.HEART_HALF_SOUL, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_soul_half.anm2", Dataflags = {{"hollowanim", true}}},
	                  {ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 9, PickupID = 5, PickupVar = 10, PickupSub = HeartSubType.HEART_SOUL, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_soul.anm2", Dataflags = {}}},
	["BLACK_HEART"] = {{ID = 1000, Var = mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, Sub = 1, PickupID = nil, PickupVar = nil, PickupSub = nil, PickupAnim = nil, Dataflags = {{"hollow", true}, {"canreroll", false}, {"fiendBonus", true}}},
	                   {ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 1, PickupID = 5, PickupVar = 10, PickupSub = HeartSubType.HEART_BLACK, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_black.anm2", Dataflags = {{"fiendBonus", true}}}},
	["IMMORAL_HEART"] = {{ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 3, PickupID = 5, PickupVar = mod.PICKUP.VARIANT.HALF_IMMORAL_HEART, PickupSub = 1, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_fiendish_half.anm2", Dataflags = {{"hollowanim", true}}},
	                     {ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 2, PickupID = 5, PickupVar = mod.PICKUP.VARIANT.IMMORAL_HEART, PickupSub = 1, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_fiendish.anm2", Dataflags = {}}},
	["ETERNAL_HEART"] = {{ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 4, PickupID = 5, PickupVar = 10, PickupSub = HeartSubType.HEART_ETERNAL, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_eternal_half.anm2", Dataflags = {{"hollowanim", true}}}},
	["GOLDEN_HEART"] = {{ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 5, PickupID = 5, PickupVar = 10, PickupSub = HeartSubType.HEART_GOLDEN, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_gold.anm2", Dataflags = {}}},
	["FOOLS_GOLD_HEART"] = {{ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 11, PickupID = 5, PickupVar = mod.PICKUP.VARIANT.FOOLS_GOLD_HEART, PickupSub = 1, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_fools_gold.anm2", Dataflags = {{"fiendBonus", true}}}},
	["MORBID_HEART"] = {{ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 14, PickupID = 5, PickupVar = mod.PICKUP.VARIANT.THIRD_MORBID_HEART, PickupSub = 1, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_morbid_third.anm2", Dataflags = {{"hollowanim", true}}},
	                    {ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 13, PickupID = 5, PickupVar = mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, PickupSub = 1, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_morbid_twothirds.anm2", Dataflags = {{"hollowanim", true}}},
	                    {ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 12, PickupID = 5, PickupVar = mod.PICKUP.VARIANT.MORBID_HEART, PickupSub = 1, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_morbid.anm2", Dataflags = {}}},
	["STEVEN_HEART"] = {{ID = 5, Var = FiendFolio.PICKUP.VARIANT.FIEND_MINION, Sub = 15, PickupID = 5, PickupVar = mod.PICKUP.VARIANT.STEVEN_HEART, PickupSub = 1, PickupAnim = "gfx/familiar/fiend/minions/morsel_minion_steven.anm2", Dataflags = {}}},
}

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, p, useflags, activeslot, customvardata)
	local player = p
	local ptype = player:GetPlayerType()
	if ptype == PlayerType.PLAYER_THESOUL_B then
		if player:GetOtherTwin() ~= nil then
			player = player:GetOtherTwin()
		end
	end
	
	if CustomHealthAPI.Helper.PlayerIsIgnored(player) or ptype == FiendFolio.PLAYER.CHINA then
		return
	end
	
	local heartsRemoved = {}

	heartsRemoved["ETERNAL_HEART"] = player:GetEternalHearts()
	heartsRemoved["GOLDEN_HEART"] = player:GetGoldenHearts()
	heartsRemoved["FOOLS_GOLD_HEART"] = mod.GetFoolsGoldHeartsNum(player)
	heartsRemoved["STEVEN_HEART"] = mod.GetStevenHeartsNum(player)

	player:AddEternalHearts(-1 * heartsRemoved["ETERNAL_HEART"])
	player:AddGoldenHearts(-1 * heartsRemoved["GOLDEN_HEART"])
	mod:AddFoolsGoldHearts(player, -1 * heartsRemoved["FOOLS_GOLD_HEART"])
	mod:AddStevenHearts(player, -1 * heartsRemoved["STEVEN_HEART"])
	
	local redHeartsToRemove = math.floor(player:GetHearts() / 2)
	if redHeartsToRemove == 0 and player:GetHearts() > 0 and player:GetBoneHearts() > 0 then
		redHeartsToRemove = player:GetHearts()
	end
	
	local soulHeartsToRemove = math.floor(player:GetSoulHearts() / 2)
	if soulHeartsToRemove == 0 and player:GetSoulHearts() > 0 and player:GetHearts() + player:GetBoneHearts() > 0 then
		soulHeartsToRemove = player:GetSoulHearts()
	end
	
	local hearts = CustomHealthAPI.Library.GetHealthInOrder(player)
	
	for i = #hearts, 1, -1 do
		local health = hearts[i]
		if health.Red ~= nil then
			local key = health.Red.Key
			local maxHPOfKey = CustomHealthAPI.Library.GetInfoOfKey(key, "MaxHP")
			
			if maxHPOfKey <= 1 then
				if redHeartsToRemove < 2 and player:GetHearts() - 2 == 0 and player:GetBoneHearts() == 0 then
					break
				else
					heartsRemoved[key] = (heartsRemoved[key] or 0) + 1
					redHeartsToRemove = redHeartsToRemove - 2
					CustomHealthAPI.Library.RemoveRedKey(player, i)
				end
			else
				if redHeartsToRemove >= health.Red.HP then
					heartsRemoved[key] = (heartsRemoved[key] or 0) + health.Red.HP
					redHeartsToRemove = redHeartsToRemove - health.Red.HP
					CustomHealthAPI.Library.RemoveRedKey(player, i)
				else
					heartsRemoved[key] = (heartsRemoved[key] or 0) + redHeartsToRemove
					health.Red.HP = health.Red.HP - redHeartsToRemove
					redHeartsToRemove = 0
					CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
				end
			end
		end
		
		if redHeartsToRemove <= 0 then
			break
		end
	end
	
	for i = #hearts, 1, -1 do
		local health = hearts[i]
		local key = health.Other.Key
		local typeOfKey = CustomHealthAPI.Library.GetInfoOfKey(key, "Type")
		
		if typeOfKey == CustomHealthAPI.Enums.HealthTypes.SOUL then
			local maxHPOfKey = CustomHealthAPI.Library.GetInfoOfKey(key, "MaxHP")
			
			if maxHPOfKey <= 1 then
				if soulHeartsToRemove < 2 and player:GetSoulHearts() - 2 == 0 and player:GetHearts() + player:GetBoneHearts() == 0  then
					break
				else
					heartsRemoved[key] = (heartsRemoved[key] or 0) + 1
					soulHeartsToRemove = soulHeartsToRemove - 2
					CustomHealthAPI.Library.RemoveOtherKey(player, i)
				end
			else
				if soulHeartsToRemove >= health.Other.HP then
					heartsRemoved[key] = (heartsRemoved[key] or 0) + health.Other.HP
					soulHeartsToRemove = soulHeartsToRemove - health.Other.HP
					CustomHealthAPI.Library.RemoveOtherKey(player, i)
				else
					heartsRemoved[key] = (heartsRemoved[key] or 0) + soulHeartsToRemove
					health.Other.HP = health.Other.HP - soulHeartsToRemove
					soulHeartsToRemove = 0
					CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
				end
			end
		end
		
		if soulHeartsToRemove <= 0 then
			break
		end
	end

	local eggs = {}
	
	for k, amount in pairs(heartsRemoved) do
		local key = k
		if not FiendFolio.FiendMixMinions[key] then
			local typeOfKey = CustomHealthAPI.Library.GetInfoOfKey(key, "Type")
			if typeOfKey == CustomHealthAPI.Enums.HealthTypes.RED then
				key = "RED_HEART"
			elseif typeOfKey == CustomHealthAPI.Enums.HealthTypes.SOUL then
				key = "SOUL_HEART"
			else
				key = "GOLDEN_HEART"
			end
		end
		
		local amountToRemove = amount
		while amountToRemove > 0 do
			local hasSpawned = false
			for i = amountToRemove, 1, -1 do
				if FiendFolio.FiendMixMinions[key][i] ~= nil then
					local config = FiendFolio.FiendMixMinions[key][i]
					
					local egg = Isaac.Spawn(config.ID, 
					                        config.Var, 
					                        config.Sub, 
					                        player.Position, 
					                        Vector(math.random(-5, 5), 
					                        math.random(-5, 5)), 
					                        player)
					table.insert(eggs, egg)
					for _, dataflag in ipairs(config.Dataflags) do
						mod:GetEntityData(egg)[dataflag[1]] = dataflag[2]
					end
					
					amountToRemove = amountToRemove - i
					hasSpawned = true
					break
				end
			end
			
			if not hasSpawned then break end
		end
	end

	local isActiveRoom = mod.IsActiveRoom()
	for _,egg in ipairs(eggs) do
		egg:GetSprite():Play("Drop", true)
		if math.random(2) == 1 then
			egg:GetSprite().FlipX = true
		end

		if not isActiveRoom then
			mod:GetEntityData(egg).mixPersistent = true
			mod:GetEntityData(egg).mixRemainingRooms = 1
			egg:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		end

		egg.Parent = player
		egg:Update()
	end
	
	local hasVirtues = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
	if hasVirtues then
		for i = 1, #eggs do
			player:AddWisp(FiendFolio.ITEM.COLLECTIBLE.FIEND_MIX, player.Position)
		end
		if #eggs > 0 then
			sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
		end
	end

	return useflags ~= useflags | UseFlag.USE_NOANIM
end, FiendFolio.ITEM.COLLECTIBLE.FIEND_MIX)

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
	for _, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, FiendFolio.ITEM.COLLECTIBLE.FIEND_MIX)) do
		mod:GetEntityData(wisp).NoSpawn = true
		wisp:Kill()
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, e)
	if e.Variant == FamiliarVariant.WISP and e.SubType == FiendFolio.ITEM.COLLECTIBLE.FIEND_MIX then
		local player = e:ToFamiliar().Player
		if player and not mod:GetEntityData(e).NoSpawn then
			local egg = Isaac.Spawn(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 1, e.Position, nilvector, player)
			mod:GetEntityData(egg).canreroll = false
			egg.EntityCollisionClass = 4
			egg.Parent = player
			mod:GetEntityData(egg).hollow = true
			
			egg:GetSprite():Play("Drop", true)
			if math.random(2) == 1 then
				egg:GetSprite().FlipX = true
			end

			local isActiveRoom = mod.IsActiveRoom()
			if not isActiveRoom then
				mod:GetEntityData(egg).mixPersistent = true
				mod:GetEntityData(egg).mixRemainingRooms = 1
				egg:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
			end
			
			egg:Update()
		end
	end
end, EntityType.ENTITY_FAMILIAR)
