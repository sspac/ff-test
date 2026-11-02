-- Soul Shards --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local randomPickupChance = 0.001 -- i want this shit ultra rare
local randomShopChance = 0.001 -- note that these will also depend on if the shop even contains the replaceable pickup, so the actual chance is probably less
local boostedShopChance = 0.5
local randomRoomChance = 0.005
local boostedRoomChance = 0.5
local roomslist = StageAPI.RoomsList("SoulShardSuperSecrets", require("resources.luarooms.soulshard_supersecrets"))

local function areSoulShardsUnlocked()
	return mod.ACHIEVEMENT.SOUL_SHARD:IsUnlocked() and mod.ACHIEVEMENT.INABA:IsUnlocked(true)
end

--------------------
-- Room behaviour --
--------------------

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level')
	d.StartedFloorWithSoulShards = false
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		local data = mod:GetEntityData(player)
		local sdata = data.ffsavedata
		if (sdata.ffSoulShards or 0) % 3 ~= 0 then
			d.StartedFloorWithSoulShards = true
			break
		end
	end
	
	local level = game:GetLevel()
	local rooms = level:GetRooms()
	for i = 0, rooms.Size - 1 do
		local roomDesc = rooms:Get(i)
		if roomDesc:GetDimension() == Dimension.NORMAL and roomDesc.Data.Type == RoomType.ROOM_SUPERSECRET then
			local rng = RNG()
			rng:SetSeed(math.max(1, roomDesc.DecorationSeed), 0)
			
			local chance = (d.StartedFloorWithSoulShards and boostedRoomChance) or (areSoulShardsUnlocked() and randomRoomChance) or -1
			if rng:RandomFloat() < chance then
				roomDesc.Data = StageAPI.GetGotoDataForTypeShape(RoomType.ROOM_SUPERSECRET, roomDesc.Data.Shape)
				local levelRoom = StageAPI.LevelRoom{
					RoomType = RoomType.ROOM_SUPERSECRET,
					RequireRoomType = true,
					RoomsList = roomslist,
					RoomDescriptor = roomDesc
				}
				StageAPI.SetLevelRoom(levelRoom, roomDesc.ListIndex, Dimension.NORMAL)
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_BACKDROP_CHANGE, function()
	local stageAPIRoom = StageAPI.GetCurrentRoom()
	if stageAPIRoom and stageAPIRoom.RoomsListName == "SoulShardSuperSecrets" then
		return stageAPIRoom.Layout.SubType
	end
end)

------------------------
-- Spawning behaviour --
------------------------

local grng = RNG()
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, et, ev, es, pos, vel, sp, seed)
	if areSoulShardsUnlocked() and et == EntityType.ENTITY_PICKUP and (ev == 0 or (ev == PickupVariant.PICKUP_HEART and es == 0)) then
		grng:SetSeed(math.max(1, seed), 0)
		if grng:RandomFloat() < randomPickupChance then
			return {EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.SOUL_SHARD, 0, seed}
		end
	end
end)

local ReplaceableShopItemTypes = {
	{0, function(pickup) return pickup.Variant == PickupVariant.PICKUP_HEART and (pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_DOUBLEPACK) end},
	{1, function(pickup) return pickup.Variant == PickupVariant.PICKUP_BOMB end},
	{2, function(pickup) return pickup.Variant == PickupVariant.PICKUP_PILL end},
	{3, function(pickup) return pickup.Variant == PickupVariant.PICKUP_KEY end},
	{4, function(pickup) return pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType == HeartSubType.HEART_SOUL end},
	{5, function(pickup) return pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY end},
	{6, function(pickup) return pickup.Variant == PickupVariant.PICKUP_TAROTCARD end},
	{7, function(pickup) return pickup.Variant == PickupVariant.PICKUP_GRAB_BAG end},
}

local tryingToSpawnShopPickup = nil
local potentialNewShopPickups = {}
function mod:makeNewShopPickupsIntoSoulShards()
	local room = game:GetRoom()
	if room:GetType() == RoomType.ROOM_SHOP then
		-- hopefully the award seed never changes inside a room
		-- oh bloody hell i sure hope the award seed never changes inside a room
		local replacingShopItemType = nil
		local rng = RNG()
		rng:SetSeed(math.max(1, room:GetAwardSeed()), 0)
		repeat
			replacingShopItemType = rng:RandomInt(8)
		until (not game:IsGreedMode() or (replacingShopItemType ~= 0 and replacingShopItemType ~= 3))
		
		local pickupsToReplace = {}
		for _, pickup in ipairs(potentialNewShopPickups) do
			if pickup:Exists() and pickup:IsShopItem() then
				for _, typ in ipairs(ReplaceableShopItemTypes) do
					if typ[1] == replacingShopItemType and typ[2](pickup) then
						table.insert(pickupsToReplace, pickup)
						break
					end
				end
			end
		end
		
		if #pickupsToReplace > 0 then
			-- i'd roll for each pickup but if more than one gets replaced in a frame then shit's gonna break
			local rng = RNG()
			rng:SetSeed(math.max(1, game:GetRoom():GetAwardSeed()), 15)
			
			local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level')
			local chance = (d.StartedFloorWithSoulShards and boostedShopChance) or (areSoulShardsUnlocked() and randomShopChance) or -1
			if rng:RandomFloat() < chance then
				for _, pickup in ipairs(pickupsToReplace) do
					local shopItemId = pickup.ShopItemId
					pickup:Morph(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.SOUL_SHARD, 0)
					pickup:MakeShopItem(shopItemId)
				end
			end
		end
	end
	
	potentialNewShopPickups = {}
	tryingToSpawnShopPickup = nil
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.makeNewShopPickupsIntoSoulShards)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_ROOM_EXIT, math.huge, mod.makeNewShopPickupsIntoSoulShards)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.makeNewShopPickupsIntoSoulShards)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, math.huge, function(_, et, ev, es, pos, vel, sp, seed)
	if et == EntityType.ENTITY_PICKUP and ev == PickupVariant.PICKUP_SHOPITEM then
		tryingToSpawnShopPickup = true
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_INIT, -1 * math.huge, function(_, pickup)
	if tryingToSpawnShopPickup then
		table.insert(potentialNewShopPickups, pickup)
		tryingToSpawnShopPickup = nil
	end
end)

----------------------
-- Pickup behaviour --
----------------------

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	CustomHealthAPI.Helper.CustomPickupMagnetoCheck(pickup)
	local sprite = pickup:GetSprite()
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle", true)
	end
	if sprite:IsFinished("Collect") then
		pickup:Remove()
	end
	if sprite:IsEventTriggered("DropSound") then
        sfx:Play(SoundEffect.SOUND_SCAMPER, 0.75, 0, false, 1.3)
	end
end, mod.PICKUP.VARIANT.SOUL_SHARD)

mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CustomHealthAPI.Enums.CallbackPriorities.LATE, function(_, pickup)
	if pickup:IsShopItem() and pickup.AutoUpdatePrice then
		pickup.Price = CustomHealthAPI.Helper.GetPriceOfPickup(pickup, force, 10)
	
		local priceSprite = pickup:GetPriceSprite()
		if pickup.Price >= 10 then
			priceSprite.Color = Color(0,0,0,1,1,1,1)
		elseif pickup.Price >= 0 then 
			priceSprite.Color = Color(0,0,0,1,180/255,0,0)
		else
			priceSprite.Color = Color(1,1,1,1,0,0,0)
		end
	end
end, mod.PICKUP.VARIANT.SOUL_SHARD)

function mod:addSoulShard(player, num)
	if player == nil then return end
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata
	
	local soulRevivesBefore = math.floor((sdata.ffSoulShards or 0) / 3)
	local soulRevivesAfter = math.floor(((sdata.ffSoulShards or 0) + num) / 3)
	if soulRevivesAfter > soulRevivesBefore and not FiendFolio.ACHIEVEMENT.CHARACTER_SELECT:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.CHARACTER_SELECT:Unlock()
	end
	
	sdata.ffSoulShards = ((sdata.ffSoulShards or 0) + num)
	if num > 0 then 
		data.ffFrameSoulShardGained = game:GetFrameCount()
	end
end

function mod:soulShardCollision(pickup, collider, low)
	if collider.Type == EntityType.ENTITY_PLAYER then
		local collider = collider:ToPlayer()
		local sprite = pickup:GetSprite()

		local data = mod:GetEntityData(pickup)
		if collider:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and CustomHealthAPI.Helper.IsHoldingTaintedForgotten(collider) then
			return mod:soulShardCollision(pickup, collider:GetOtherTwin())
		elseif pickup:IsShopItem() and
		       (pickup.Price > collider:GetNumCoins() or
			    (not collider:IsExtraAnimationFinished() and not data.CHAPIHeartPickupSpentSpikesCostAlready))
		then
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
			return true
		elseif sprite:IsPlaying("Collect") then
			return true
		elseif pickup.Wait > 0 then
			return not sprite:IsPlaying("Idle")
		elseif sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle") then
			if pickup.Price == PickupPrice.PRICE_SPIKES and 
			   not (data.CHAPIHeartPickupSpentSpikesCostAlready or 
			        collider:GetPlayerType() == PlayerType.PLAYER_JACOB2_B or 
			        collider:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE))
			then
				local tookDamage = collider:TakeDamage(2.0, 268435584, EntityRef(nil), 30)
				if not tookDamage then
					Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
					return pickup:IsShopItem()
				end
			end
			
			local pdata = mod:GetEntityData(collider)
			local soulShardsBefore = pdata.ffsavedata.ffSoulShards or 0
			if collider:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
				mod:addSoulShard(collider:GetOtherTwin(), 1)
			else
				mod:addSoulShard(collider, 1)
			end
			local soulShardsAfter = pdata.ffsavedata.ffSoulShards or 0
			if soulShardsBefore == 0 or math.floor(soulShardsBefore / 3) == math.floor(soulShardsAfter / 3) then
				sfx:Play(SoundEffect.SOUND_GOLD_HEART, 0.75, 0, false, 1.1)
				sfx:Play(SoundEffect.SOUND_FORTUNE_COOKIE, 1.1, 0, false, 0.8)
			else
				sfx:Play(SoundEffect.SOUND_GOLD_HEART, 0.4, 0, false, 1.25)
				sfx:Play(SoundEffect.SOUND_FORTUNE_COOKIE, 1.1, 0, false, 0.8)
				sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 2.3, 0, false, 0.65)
			end

			if pickup.OptionsPickupIndex ~= 0 then
				local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
				for _, entity in ipairs(pickups) do
					if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
					   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
					then
						Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
						entity:Remove()
					end
				end
			end

			if pickup:IsShopItem() then
				local pickupSprite = pickup:GetSprite()
				local holdSprite = Sprite()

				holdSprite:Load(pickupSprite:GetFilename(), true)
				holdSprite:Play(pickupSprite:GetAnimation(), true)
				holdSprite:SetFrame(pickupSprite:GetFrame())
				collider:AnimatePickup(holdSprite)

				if pickup.Price > 0 then
					collider:AddCoins(-1 * pickup.Price)
				end

				CustomHealthAPI.Library.TriggerRestock(pickup, nil, 10)
				CustomHealthAPI.Helper.TryRemoveStoreCredit(collider)

				pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				pickup:Remove()
			else
				sprite:Play("Collect", true)
				pickup.Velocity = Vector.Zero
				pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				pickup:Die()
			end

			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
			return true
		else
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.soulShardCollision, mod.PICKUP.VARIANT.SOUL_SHARD)

----------------------
-- Revive behaviour --
----------------------

-- Called from `ffscripts/revives.lua`
function mod.TrySoulShardsRevive(player, data, effs)
	local sdata = data.ffsavedata
	if (sdata.ffSoulShards or 0) >= 3 then
		sdata.ffSoulShards = math.max(0, (sdata.ffSoulShards or 0) - 3)
		player:Revive()
		player:SetFullHearts()
        player:SetMinDamageCooldown(100)
		
		local soulShardPoof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 11, player.Position, nilvector, player):ToEffect()
		soulShardPoof:FollowParent(player)
		soulShardPoof.DepthOffset = 16
		
		local sprite = soulShardPoof:GetSprite()
		sprite:ReplaceSpritesheet(0, "gfx/effects/soul_shard_break.png")
		sprite:LoadGraphics()
	
		local rand = math.random(360)
		for i = 1, 5 do
			local gib = Isaac.Spawn(1000, EffectVariant.TOOTH_PARTICLE, 922, player.Position, Vector(4,0):Rotated(rand + 72 * i + math.random(-45,45)), player):ToEffect()
			gib.m_Height = -15
		end
		
		sfx:Play(SoundEffect.SOUND_GLASS_BREAK, 0.8, 0, false, 0.75)
		sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.5, 0, false, 1.5)
		sfx:Play(SoundEffect.SOUND_HOLY_MANTLE, 0.5, 0, false, 1.0)
		sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 2, 0, false, 0.5)
	end
end

--------------------------
-- Soul shard rendering --
--------------------------

local soulShardSprite = Sprite()
soulShardSprite:Load("gfx/ui/soul_shards.anm2", true)

local function checkDangerHealth(player)
	local playertype = player:GetPlayerType()
	local data = mod:GetEntityData(player)
	return player:IsDead() or
	       ((player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE) or 
	         player:GetPlayerType() == PlayerType.PLAYER_JACOB2_B or 
	         CustomHealthAPI.Helper.GetTotalHP(player) + player:GetEternalHearts() <= 1 or
	         (player:GetPlayerType() == mod.PLAYER.CHINA and player:GetBrokenHearts() >= 11) or
	         data.MaliceSplit and playerSlot ~= CustomHealthAPI.Enums.PlayerSlot.STRAWMAN and #data.MaliceMinions <= 1) and
	        not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE))
end

function mod.shouldRenderSoulShardsIcon(player, playerSlot)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata
	if sdata then
		return (sdata.ffSoulShards or 0) > 0
	end
end

function mod.onRenderSoulShardsIcon(player, playerSlot, healthIndex, renderInfo)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata
	local numSoulShards = sdata.ffSoulShards or 0
	if numSoulShards <= 0 then return end

	local soulColor = Color(1,1,1,1,0,0,0)
	if numSoulShards >= 3 and checkDangerHealth(player) then
		local regularColor = Color(1,1,1,1,0,0,0)
		local dangerPulseColorHigh = Color(1,1,1,1,1,4/5,4/5)
		soulColor = Color.Lerp(regularColor, dangerPulseColorHigh, math.max(0, ((Game():GetFrameCount() % 45) - 9) / 9 * -1))
	end
	local shouldGainFlash = game:GetFrameCount() - (mod:GetEntityData(player).ffFrameSoulShardGained or (game:GetFrameCount() - 5)) < 4
	if shouldGainFlash then
		soulColor = Color(1,1,1,1,128/255,102/255,102/255)
	end
	
	-- to render only two icons
	if numSoulShards > 6 then
		if numSoulShards % 3 == 1 then
			numSoulShards = 4
		elseif numSoulShards % 3 == 2 then
			numSoulShards = 5
		else
			numSoulShards = 6
		end
	end
	
	while numSoulShards > 0 do
		if numSoulShards >= 3 then
			soulShardSprite:Play("SoulShardFull", true)
		elseif numSoulShards == 2 then
			soulShardSprite:Play("SoulShardHalf", true)
		else
			soulShardSprite:Play("SoulShardThird", true)
		end
		
		soulShardSprite.Color = soulColor
		local extraOffset = renderInfo.ExtraOffset
		if numSoulShards > 3 then
			extraOffset = extraOffset + Vector(3, -2)
			soulShardSprite.Color.A = 0.5
		else
			soulShardSprite.Color.A = 1
		end

		CustomHealthAPI.Helper.RenderHealth(soulShardSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, extraOffset)
		numSoulShards = numSoulShards - 3
	end
end

CustomHealthAPI.Library.RegisterAfterHealthIcon("SOUL_SHARDS", 
	{SortOrder = 9999,
	 ShouldRenderFunc = mod.shouldRenderSoulShardsIcon,
	 OnRenderFunc = mod.onRenderSoulShardsIcon,})

function mod:onRenderSoulShardsLives(player, lives, isChance, heartsRenderedOffset, columnOffset)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata
	local numSoulShards = sdata.ffSoulShards or 0
	if numSoulShards >= 3 or (numSoulShards > 0 and lives > 0) then 
		return {Lives = lives + math.floor(numSoulShards / 3)}
	end
end
mod:AddPriorityCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_LIVES, 1, mod.onRenderSoulShardsLives)

-----------
-- Other --
-----------

function mod:HasSoulstoneUnlocked()
	local persistentGameData = Isaac.GetPersistentGameData()
	return persistentGameData:Unlocked(Achievement.SOUL_OF_ISAAC) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_MAGDALENE) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_CAIN) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_JUDAS) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_BLUE_BABY) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_EVE) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_SAMSON) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_AZAZEL) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_LAZARUS) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_EDEN) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_THE_LOST) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_LILITH) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_THE_KEEPER) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_APOLLYON) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_THE_FORGOTTEN) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_BETHANY) or
	       persistentGameData:Unlocked(Achievement.SOUL_OF_JACOB) or
	       FiendFolio.ACHIEVEMENT.SOUL_OF_FIEND:IsUnlocked() or
	       FiendFolio.ACHIEVEMENT.SOUL_OF_GOLEM:IsUnlocked() or
	       FiendFolio.ACHIEVEMENT.CRAIGS_UNLOCKS:IsUnlocked() or
	       (FiendFolio.ACHIEVEMENT.SOUL_OF_INABA:IsUnlocked() and FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true))
end

mod:AddCallback(ModCallbacks.MC_GET_TRINKET, function(_, trinket, rng)
	if trinket == mod.ITEM.TRINKET.CHARACTER_SELECT and not mod:HasSoulstoneUnlocked() then
		local itempool = game:GetItemPool()
		itempool:RemoveTrinket(mod.ITEM.TRINKET.CHARACTER_SELECT)
		
		local new = itempool:GetTrinket()
		return new
	end
end)