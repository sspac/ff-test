local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("HONEY")

local tearcolor = Color(1, 1, 1, 1, 40/255, 25/255, 0/255, 1.2, 0.77, 0.26, 1)
local lasercolor = Color(1, 1, 1, 1, 0/255, 0/255, 0/255, 5.5, 3.5, 1, 1)

function mod:honeyPennyLaserColor(player)
	if mod:GetEntityData(player).HoneyPenny then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, mod.honeyPennyLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:honeyPennyPeffect(player, basedata)
	if basedata.HoneyPenny == true then
		if player.FrameCount % (#mod.creepSpawnerCount * 4 - 1) == 1 and not player:HasCollectible(CollectibleType.COLLECTIBLE_AQUARIUS) then
			local honeycolor = Color(1,1,1,1,0,0,0)
			honeycolor:SetColorize(5.5, 3.5, 1, 1)
			local creepSlowEnt = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK, 0, player.Position, Vector(0,0), player);
			local creepSlow = creepSlowEnt:ToEffect()
			creepSlowEnt.Visible = false
			creepSlow.SpriteScale = Vector(0.4, 0.4)
			creepSlow:SetTimeout(30)
			local creepHoneyEnt = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector(0,0), player);
			local creepHoney = creepHoneyEnt:ToEffect()
			creepHoneyEnt.CollisionDamage = 0
			creepHoneyEnt:SetColor(honeycolor,99999, 1, false, false)
			creepHoney.SpriteScale = Vector(0.2, 0.2)
			creepHoney:SetTimeout(30)
			creepHoney:Update()
		end
		basedata.HoneyPennyTimer = basedata.HoneyPennyTimer-1
		if basedata.HoneyPennyTimer <= 0 then
			basedata.HoneyPenny = nil
			basedata.HoneyPennyTimer = nil
			player:AddCacheFlags(CacheFlag.CACHE_TEARCOLOR)
			player:EvaluateItems()
		end
	end
end

function mod:honeyPennyFlagGeneric(entity, player, weaponFlag)
	if mod:GetEntityData(player).HoneyPenny then
		TearFlagsLib.AddTearFlags(entity, flag)
		
		if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
			mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
		elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
			mod:GetEntityData(entity).FFExplosionColor = tearcolor
		elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
		       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
		       weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
		       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
		       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
		       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
		       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
		       weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or
		       weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
		       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
		       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
		then
			return
		else
			entity.Color = tearcolor
		end
	end
end
mod:AddPriorityCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, CallbackPriority.LATE, mod.honeyPennyFlagGeneric)

function mod:applyHoneySlow(entity, player, source)
	if not entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and entity:ToNPC() then
		local honeycolor = Color(1.2, 0.77, 0.26, 1, 40/255, 25/255, 0/255, 1.2, 0.77, 0.26, 0.5)
		entity:AddSlowing(EntityRef(player),30,0.5,honeycolor)
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyHoneySlow, flag)

function mod:honeyPennyCollide(pickup, opp, low)
	if pickup.SubType ~= 215 then return end

	if opp:ToPlayer() or
	   (opp:ToFamiliar() and (opp.Variant == FamiliarVariant.BUM_FRIEND or
							  opp.Variant == FamiliarVariant.BUMBO or
							  opp.Variant == FamiliarVariant.SUPER_BUM))
	then
		local sprite = pickup:GetSprite()
		if not (sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle")) then
			return false
		end

		local player = opp:ToPlayer()
		local familiar = opp:ToFamiliar()

		if player then
			player:AddCoins(1)
			mod:triggerPennyPickup(player, pickup, 1)

			local data = mod:GetEntityData(player)
			--[[if data.HoneyPenny ~= true then
				local iconEnt = Isaac.Spawn(EntityType.ENTITY_EFFECT, 1748, 0, player.Position, player.Velocity, nil)
				iconEnt:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
				local icon = iconEnt:ToEffect()
				icon.Parent = player
				icon:FollowParent(player)
				icon.DepthOffset = 1
				icon:Update()
				iconEnt:GetSprite():Play("Honey")
			end]]-- --this is now handled in status code

			local hadPenny = data.HoneyPenny
			data.HoneyPenny = true
			data.HoneyPennyTimer = 60*8
			if not hadPenny then
				player:AddCacheFlags(CacheFlag.CACHE_TEARCOLOR)
				player:EvaluateItems()
			end
		elseif familiar then
			familiar.Coins = familiar.Coins + 1
		end
		sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH, 1.3, 0, false, 1)
		sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0, false, 1)

		if pickup.OptionsPickupIndex ~= 0 then
			local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
			for _, entity in ipairs(pickups) do
				if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
				   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
				then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
					entity:Remove()
				end
			end
		end

		pickup.Velocity = nilvector
		pickup.Touched = true
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sprite:Play("Collect", true)
		pickup:Die()

		Game():SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)

		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, opp, low)
		return true
	elseif opp.Type == EntityType.ENTITY_ULTRA_GREED or
		   opp.Type == EntityType.ENTITY_BUMBINO
	then
		pickup.SubType = 1
		return
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.honeyPennyCollide, 20)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if pickup.SubType == 215 then
		if pickup:GetSprite():IsEventTriggered("DropSound") then
			sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH, 1.3, 0, false, 1)
		end
	end
end, 20)