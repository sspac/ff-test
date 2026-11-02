local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

if StageAPI and StageAPI.Loaded then
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.SKELETAL_FIEND, {
        Name = "gfx/ui/boss/playername_skeletal_fiend.png",
        Portrait = "gfx/ui/stage/playerportrait_skeletal_fiend.png",
        NoShake = false
    })
end

local guitar = {mod.Sounds.RMetalCombo11, mod.Sounds.RMetalCombo12, mod.Sounds.RMetalCombo13}

local roomCenter = Vector(320, 280)

function mod:initialiseSkeletalFiend(player, data)
	data = data or mod:GetEntityData(player)
	data.SuccessfulSkeletalFiendInit = true
	local sdata = data.ffsavedata
	if not sdata.SuccessfulSkeletalFiendInit then
		sdata.SuccessfulSkeletalFiendInit = true
		--player:SetPocketActiveItem(mod.ITEM.COLLECTIBLE.BONE_HURTING_JUICE, ActiveSlot.SLOT_POCKET, false)
		if mod.ACHIEVEMENT.SKELETALFIEND_BABY:IsUnlocked() then
			local bobby = Isaac.Spawn(3, mod.ITEM.FAMILIAR.FRAGILE_BOBBY, 0, player.Position, Vector.Zero, player)
			bobby:Update()
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_STARS:IsUnlocked() then
			player:AddCard(Card.CARD_REVERSE_STARS)
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_CURVED_HORN:IsUnlocked() then
			player:AddTrinket(TrinketType.TRINKET_CURVED_HORN)
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_SPEED_UP:IsUnlocked()
		or mod.ACHIEVEMENT.SKELETALFIEND_SHOTSPEED_UP:IsUnlocked()
		then
			if mod.ACHIEVEMENT.SKELETALFIEND_SPEED_UP:IsUnlocked() then
				player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			end
			if mod.ACHIEVEMENT.SKELETALFIEND_SHOTSPEED_UP:IsUnlocked() then
				player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
			end
			player:EvaluateItems()
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_POOP:IsUnlocked() then
			mod.scheduleForUpdate(function()
				local poopPos = roomCenter + Vector(-120,80)
				sfx:Play(SoundEffect.SOUND_FART)
				--Isaac.GridSpawn(GridEntityType.GRID_POOP, 0, poopPos, true)
				local poop = Isaac.Spawn(EntityType.ENTITY_POOP, 0, 0, poopPos, Vector.Zero, nil)
			end, 1, ModCallbacks.MC_POST_UPDATE, true)
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_BETTER_ITEM:IsUnlocked() then
			player:AddNullItemEffect(mod.ITEM.NULL.SKELETAL_FIENDS_BETTER_ITEM)
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_SLOT_MACHINE:IsUnlocked() then
			mod.scheduleForUpdate(function()
				local slotPos = roomCenter + Vector(100,-100)
				local slot = Isaac.Spawn(EntityType.ENTITY_SLOT, 1, 0, slotPos, Vector.Zero, nil)
				local poof = Isaac.Spawn(1000, 15, 0, slotPos, Vector.Zero, nil)
				sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
			end, 1, ModCallbacks.MC_POST_UPDATE, true)
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_A_PENNY:IsUnlocked() then
			player:AddCoins(1)
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_ANOTHER_PENNY:IsUnlocked() then
			player:AddCoins(1)
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_FIREBONE:IsUnlocked() then
			sdata.orbitingfireballs = 1
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			player:EvaluateItems()
			mod.SkeletalFiendRequestsNoCandleSounds = true
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_HIS_PET:IsUnlocked() then
			mod.scheduleForUpdate(function()
				local princess = Isaac.Spawn(EntityType.ENTITY_CHARGER, 3, 0, roomCenter, Vector.Zero, nil)
				princess:AddCharmed(EntityRef(Isaac.GetPlayer()),-1)
				princess:Update()
			end, 1, ModCallbacks.MC_POST_UPDATE, true)
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_MYSTERY_GIFT:IsUnlocked() then
			player:AddCollectible(CollectibleType.COLLECTIBLE_MYSTERY_GIFT)
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_BIRTHRIGHT:IsUnlocked() then
			player:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		end
		if mod.ACHIEVEMENT.SKELETALFIEND_SPICY_KEY:IsUnlocked() then
			mod.scheduleForUpdate(function()
				local keyPos = roomCenter + Vector(120,90)
				local slot = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, mod.PICKUP.KEY.SPICY_PERM, keyPos, Vector.Zero, nil)
			end, 1, ModCallbacks.MC_POST_UPDATE, true)
		end
	end
end
mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_INIT, mod.initialiseSkeletalFiend, FiendFolio.PLAYER.SKELETAL_FIEND)

mod:AddPlayerTempEffectCallback(ModCallbacks.MC_POST_PICKUP_INIT, Isaac.GetItemConfig():GetNullItem(mod.ITEM.NULL.SKELETAL_FIENDS_BETTER_ITEM), function(_, pickup)
	local playerWithBetterItems
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		if player:GetEffects():HasNullEffect(mod.ITEM.NULL.SKELETAL_FIENDS_BETTER_ITEM) then
			playerWithBetterItems = true
			break
		end
	end
	if playerWithBetterItems then
		mod.AnyPlayerDo(function(player)
			local eff = player:GetEffects()
			eff:RemoveNullEffect(mod.ITEM.NULL.SKELETAL_FIENDS_BETTER_ITEM, eff:GetNullEffectNum(mod.ITEM.NULL.SKELETAL_FIENDS_BETTER_ITEM))
		end)
		local room = game:GetRoom()
		local roomType = room:GetType()
		local itemPool = game:GetItemPool():GetPoolForRoom(roomType, room:GetAwardSeed())
		local roomRNG = RNG()
		roomRNG:SetSeed(room:GetAwardSeed())
		local item = mod.GetItemByLuaFilter(itemPool, roomRNG, function(configItem)
			return configItem.Quality >= 4
		end)
		item = item or game:GetItemPool():GetCollectible(itemPool, true, roomRNG:Next())
		pickup:Morph(5, 100, item, true, false, false)
	end

end, 100)

function mod:skeletalFiendPlayerUpdate(player)
	local data = mod:GetEntityData(player)
	local sprite = player:GetSprite()
	if sprite:IsPlaying("Happy") and sprite:GetFrame() == 5 then
		if not data.fientWhipcracked then
			sfx:Play(mod.Sounds.ZealotBoom, 0.5, 0, false, 1)
			data.skeletalFiendGuitar = data.skeletalFiendGuitar or 0
			data.skeletalFiendGuitar = data.skeletalFiendGuitar + 1
			data.skeletalFiendGuitar = data.skeletalFiendGuitar % 3
			sfx:Play(guitar[data.skeletalFiendGuitar + 1], 0.5, 0, false, 1.2)
			data.fientWhipcracked = true

			for i = 1, 10 do
				local emberParticle = Isaac.Spawn(1000,66, 0, player.Position + Vector(0, -20), Vector(0,-math.random(4,7)):Rotated(-35 + math.random(70)), player):ToEffect()
				emberParticle.Color = Color(1,1,1,1,-0.3,-0.3,0.3)
				emberParticle:Update()
			end

			local boom = Isaac.Spawn(1000,7012,50, player.Position, Vector.Zero, player):ToEffect()
			boom:FollowParent(player)
			boom.SpriteOffset = Vector(0, -25)
			boom:Update()

			if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
				game:MakeShockwave(player.Position, 0.035, 0.025, 10)
				local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ATTRACT, 10, player.Position, Vector.Zero, player):ToEffect()
				eff.MinRadius = 1
				eff.MaxRadius = 30
				eff.LifeSpan = 10
				eff.Timeout = 10
				eff.SpriteOffset = Vector(0, -15)
				eff.Color = Color(0.3,0.2,0.3,1,0.3,0,0.3)
				eff.Visible = false
				eff:FollowParent(player)
				eff:Update()
				eff.Visible = true

				for _, enemy in pairs(Isaac.FindInRadius(player.Position, 250, EntityPartition.ENEMY)) do
					local vec = (enemy.Position - player.Position)
					local dist = vec:Length()
					if dist < 100 + enemy.Size + player.Size then
						enemy:TakeDamage(player.Damage, 0, EntityRef(Isaac.GetPlayer(0)), 0)
					end
				end
			end
		end
	elseif sprite:IsPlaying("Sad") and sprite:GetFrame() == 1 then
		if not data.fientWhipcracked then
			data.fientWhipcracked = true
			game:Darken(1, 25)
		end
	else
		data.fientWhipcracked = false
	end

	if not Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex) then
		data.skeletalFiendLastPos = data.skeletalFiendLastPos or player.Position
		if player.Position:Distance(data.skeletalFiendLastPos) > 25 then
			data.skeletalFiendLastPos = player.Position
			data.skeletalFiendFireOffset = data.skeletalFiendFireOffset or 1
			data.skeletalFiendFireOffset = data.skeletalFiendFireOffset * -1
			local fire = Isaac.Spawn(1000,51, 0, player.Position + player.Velocity:Resized(5 * data.skeletalFiendFireOffset):Rotated(90), Vector.Zero, player):ToEffect()
			fire.Color = Color(1,1,1,0.5,-0.3,-0.3,0.3)
			fire.Scale = 0.3
			fire.Timeout = 20
			fire.DepthOffset = -10
			fire.CollisionDamage = 0.1
			fire:Update()
		end
		if player.FrameCount % 2 == 0 then
			local scorch = Isaac.Spawn(1000, 18, 0, player.Position, Vector.Zero, player):ToEffect()
			scorch.SpriteScale = Vector(1,2) * 0.25
			scorch.Color = Color(1,1,1,0.01)
			scorch.Rotation = math.random(360)
			scorch:Update()
		end
	end

	if player.FrameCount % 5 == 0 then
		mod:GetEntityData(player).ffsavedata = mod:GetEntityData(player).ffsavedata or {}
		local savedat = mod:GetEntityData(player).ffsavedata
		if savedat.skeltalFiendBuff and savedat.skeltalFiendBuff > 0 then
			savedat.skeltalFiendBuff = math.max(savedat.skeltalFiendBuff - (math.max(savedat.skeltalFiendBuff / 500, 0.01)), 0)
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	end

	if not data.SuccessfulSkeletalFiendInit then
		mod:initialiseSkeletalFiend(player, data)
	end
end
mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_UPDATE, mod.skeletalFiendPlayerUpdate, mod.PLAYER.SKELETAL_FIEND)

function mod:skeletalFiendPostFireTear(player, tear, rng, pdata, tdata, ignorePlayerEffects, isLudo)
	if player:GetPlayerType() == FiendFolio.PLAYER.SKELETAL_FIEND then
		mod:changeTearVariant(tear, TearVariant.BONE, TearVariant.BONE)
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemID, rng, player, useflags, activeslot)
    local boneCount = 0
	for _, bone in ipairs(Isaac.FindByType(3, 128, -1, false, false)) do
		if bone.Parent and bone.Parent.InitSeed == player.InitSeed then
			boneCount = boneCount + 1
			bone:Kill()
		end
	end
	if player:HasCollectible(mod.ITEM.ROCK.ELECTRUM) then
		local rng2 = player:GetTrinketRNG(mod.ITEM.ROCK.ELECTRUM)
		local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.ELECTRUM)
		mod:alternateElectrumShock(player, rng2, player.Damage*mult+boneCount*2, player.Position, boneCount)
	end
	local data = mod:GetEntityData(player).ffsavedata
	data.skeltalFiendBuff = data.skeltalFiendBuff or 0
	data.skeltalFiendBuff = data.skeltalFiendBuff + boneCount
	return true
end, mod.ITEM.COLLECTIBLE.BONE_HURTING_JUICE)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.SKELETAL_FIEND then
		--player.MaxFireDelay = player.MaxFireDelay * 3 -- direct maxfiredelay multipliers break at negative firedelay values
		player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(1.5))
	end
end, CacheFlag.CACHE_FIREDELAY)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.SKELETAL_FIEND then
		player.Damage = player.Damage * 1.5
	end
	mod:GetEntityData(player).ffsavedata = mod:GetEntityData(player).ffsavedata or {}
	local savedat = mod:GetEntityData(player).ffsavedata
	if savedat.skeltalFiendBuff then
		--print(savedat.skeltalFiendBuff, (math.log(1 + savedat.skeltalFiendBuff, 2) / 10))
		player.Damage = player.Damage * (1 + (math.log(1 + savedat.skeltalFiendBuff, 2) / 10))
	end
end, CacheFlag.CACHE_DAMAGE)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if mod:playerHasBirthcake(player) and player:GetPlayerType() == mod.PLAYER.SKELETAL_FIEND then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING | TearFlags.TEAR_ACID | TearFlags.TEAR_POP
	end
end, CacheFlag.CACHE_TEARFLAG)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.SKELETAL_FIEND then
		player.TearColor = player.TearColor * FiendFolio.ColorSkeletalFiend
	end
end, CacheFlag.CACHE_TEARCOLOR)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.SKELETAL_FIEND then
		if mod.ACHIEVEMENT.SKELETALFIEND_SPEED_UP:IsUnlocked() then
			player.MoveSpeed = player.MoveSpeed + 0.1
		end
	end
end, CacheFlag.CACHE_SPEED)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.SKELETAL_FIEND then
		if mod.ACHIEVEMENT.SKELETALFIEND_SHOTSPEED_UP:IsUnlocked() then
			player.ShotSpeed = player.ShotSpeed + 0.1
		end
	end
end, CacheFlag.CACHE_SHOTSPEED)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.SKELETAL_FIEND then
		local basemulti = player:GetD8RangeModifier()
		if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
			basemulti = basemulti * 0.8
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
		   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
		   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
		then
			basemulti = basemulti * 0.8
		end

		player.TearRange = player.TearRange - 92 * basemulti
	end
end, CacheFlag.CACHE_RANGE)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, colliding, low)
    local player = colliding:ToPlayer()
    if not player then return end

    if player:GetPlayerType() == FiendFolio.PLAYER.SKELETAL_FIEND then
        if (pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType ~= 11) then
            if pickup:IsShopItem() then
                Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, colliding, low)
                return true
            else
                Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, colliding, low)
                return false
            end
        end
    end
end)

-- HEALTH --

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_ADD_HEALTH, function(_, player, key, hp)
    if hp > 0 then
        if CustomHealthAPI.Library.GetInfoOfKey(key, "Type") == CustomHealthAPI.Enums.HealthTypes.CONTAINER then
            if CustomHealthAPI.Library.GetInfoOfKey(key, "KindContained") ~= CustomHealthAPI.Enums.HealthKinds.NONE then
                local maxHP = CustomHealthAPI.Library.GetInfoOfKey(key, "MaxHP")
				local canHaveHalfCapacity = CustomHealthAPI.Library.GetInfoOfKey(key, "CanHaveHalfCapacity")

				if maxHP < 1 then
					if canHaveHalfCapacity then
						return "BONE_HEART", math.ceil(hp / 2)
					else
						return "BONE_HEART", hp
					end
				else
					local fullKeysToAdd = math.floor(hp / maxHP)
					local newHP = fullKeysToAdd
					if hp % maxHP ~= 0 then
						newHP = newHP + 1
					end

					return "BONE_HEART", newHP
				end
            end
        elseif key ~= "BONE_HEART" then
            return true
        end
    end
end, FiendFolio.PLAYER.SKELETAL_FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.CAN_PICK_HEALTH, function(_, player, key)
    if key ~= "BONE_HEART" then
        return false
    end
end, FiendFolio.PLAYER.SKELETAL_FIEND)

--[[mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_RESYNC_PLAYER, function(_, player)
	local hearts = CustomHealthAPI.Library.GetHealthInOrder(player)
end, FiendFolio.PLAYER.SKELETAL_FIEND)]]--

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_ETERNAL_HEAL, function(_, player, key)
	return "BONE_HEART", 1
end, FiendFolio.PLAYER.SKELETAL_FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_SPIRIT_SHACKLES_HEAL, function(_, player)
	return "BONE_HEART", 1
end, FiendFolio.PLAYER.SKELETAL_FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEARTBREAK_HEAL, function(_, player)
	return "BONE_HEART", 1
end, FiendFolio.PLAYER.SKELETAL_FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_GLASS_CANNON_HEAL, function(_, player)
	return "BONE_HEART", 1
end, FiendFolio.PLAYER.SKELETAL_FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.GET_MAX_HP_CONVERSION, function(_, player)
	return "BONE_HEART"
end, FiendFolio.PLAYER.SKELETAL_FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.GET_GULLET_HEART_KEY, function(_, player)
	return "BONE_HEART"
end, FiendFolio.PLAYER.SKELETAL_FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_NOKILL_HEAL, function(_, player)
	return "BONE_HEART", 1
end, FiendFolio.PLAYER.SKELETAL_FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.GET_MAX_HP_CONVERSION, function(_, player)
	return "BONE_HEART"
end, FiendFolio.PLAYER.SKELETAL_FIEND)

function mod:anyPlayerIsSkeletalFiend()
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)

		if player:GetPlayerType() == FiendFolio.PLAYER.SKELETAL_FIEND and not player:IsCoopGhost() then
			return true
		end
	end

	return false
end

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
	sfx:Play(mod.Sounds.FiendHurt, 0.5, 0, false, 0.5)
	sfx:Play(SoundEffect.SOUND_DEATH_BURST_BONE, 1, 0, false, 0.5)
	sfx:Play(SoundEffect.SOUND_BONE_SNAP, 1, 0, false, 1)
    return true
end, mod.PLAYER.SKELETAL_FIEND)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
	sfx:Play(mod.Sounds.FiendDies, 0.8, 0, false, 0.5)
	sfx:Play(SoundEffect.SOUND_DEATH_BURST_BONE, 1, 0, false, 0.5)
	sfx:Play(SoundEffect.SOUND_BONE_SNAP, 1, 0, false, 0.75)
    return true
end, mod.PLAYER.SKELETAL_FIEND)