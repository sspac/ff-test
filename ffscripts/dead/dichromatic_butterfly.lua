local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--[[
Dichromatic Butterfly
Treasure, Secret
"Hitbox down, Danger graze"

Hitbox down, marked by the red hitbox dot.

Tears that brush close to your hitbox will "graze", which will increase your damage by +0.2 for the remainder of the room, up to +3. (grazing will have a slight cooldown?)

Graze has a cooldown of 1 second between each activation
]]

local flag = TearFlagsLib.RegisterTearFlag("YIN_YANG")

local tearcolor = Color(3.65, 1.25, 1, 1.0, -90/255, 40/255, 40/255, 0.413, 0.422, 0.657, 1.0)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 0.112, 2.52, 3.64, 1)

mod.DICHROMATIC_BUTTERFLY = {}
mod.DICHROMATIC_BUTTERFLY.LASER_HOMING_FRAMES = 5 -- how often can homing roll for lasers

local dichromaticDot = Sprite()
dichromaticDot:Load("gfx/characters/reimu_hitbox.anm2", true)
dichromaticDot:SetFrame("Hitbox", 0)

local dichromaticRadius = 25

function mod:dichromaticButterflyLaserColor(player, flag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY, mod.dichromaticButterflyLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:handleDichromaticPeffect(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) then
		local data = mod:GetEntityData(player)
		local room = game:GetRoom()

		local needsMulti = 2 / player.Size
		player.SizeMulti = Vector(needsMulti, needsMulti)

		data.dichromaticsized = true

		if data.dichromaticgrazecooldown then
			data.dichromaticgrazecooldown = data.dichromaticgrazecooldown - 1
			if data.dichromaticgrazecooldown <= 0 then
				data.dichromaticgrazecooldown = nil
			end
		end

		local newGraze
		if data.dichromaticgrazedcheck then
			for i = #data.dichromaticgrazedcheck, 1, -1 do
				local proj = data.dichromaticgrazedcheck[i]
				if not proj:Exists() then
					table.remove(data.dichromaticgrazedcheck, i)
				else
					local dist = proj.Position:DistanceSquared(player.Position)
					local distData = data.dichromaticgrazedbullets[GetPtrHash(proj)]
					if dist > distData[1] then
						distData[2] = frame
						newGraze = true
						table.remove(data.dichromaticgrazedcheck, i)
					end

					distData[1] = dist
				end
			end
		end

		local projs = Isaac.FindInRadius(player.Position, dichromaticRadius, EntityPartition.BULLET)
		if #projs > 0 then
			local frame = game:GetFrameCount()
			if not data.dichromaticgrazedbullets then
				data.dichromaticgrazedbullets = {}
				data.dichromaticgrazedcheck = {}
			end

			-- store grazing projectiles to iterate over them later and check if they are no longer grazing
			for _, proj in ipairs(projs) do
				local hash = GetPtrHash(proj)
				if not data.dichromaticgrazedbullets[hash] or (data.dichromaticgrazedbullets[hash][2] and frame > (data.dichromaticgrazedbullets[hash][2] + 30)) then
					data.dichromaticgrazedbullets[hash] = {proj.Position:DistanceSquared(player.Position)}
					data.dichromaticgrazedcheck[#data.dichromaticgrazedcheck + 1] = proj
				end
			end
		end

		local e = player:GetEffects()
		if newGraze and not data.dichromaticgrazecooldown and e:GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) < 15 then
			sfx:Play(mod.Sounds.DichromaticGraze,1,0,false,1)

			data.dichromaticgrazecooldown = 30
			-- 0.2 damage per graze, caps at 3
			--data.dichromaticgraze = (data.dichromaticgraze or 0) + 1
			e:AddCollectibleEffect(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY)
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end

		if room:GetType() == RoomType.ROOM_DUNGEON then -- hacky way to make collectibles possible to pickup in crawlspaces, by increasing their hitbox
			local colls = Isaac.FindByType(5, 100, -1, false, false)
			for _, coll in ipairs(colls) do
				coll.SizeMulti = Vector(2, 2)
			end
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY, mod.handleDichromaticPeffect)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function(_, player)
	-- sizemulti doesn't automatically reset itself; this will probably make for some funky mod interactions so sorry about that
	local data = mod:GetEntityData(player)
	if data.dichromaticsized and not player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) then
		player.SizeMulti = Vector.One
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
	end
end, mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY, function(_, player, renderOffset)
	local data = mod:GetEntityData(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY)
	and not mod.WaterRenderModes[game:GetRoom():GetRenderMode()] then
		local pos = Isaac.WorldToRenderPosition(player.Position) + game:GetRoom():GetRenderScrollOffset()
		dichromaticDot:Render(pos, nilvector, nilvector)
	end
end)

function mod:handleDichromaticNewRoom(player, data)
	if data.dichromaticgrazecooldown then
		data.dichromaticgrazecooldown = nil
		data.dichromaticgrazedbullets = nil
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
	end
end

function mod:PreventRemovingDichroFlag(entity, player, flag)
	local params = TearFlagsLib.GetTearFlagParams(entity, flag)
	if params.NoRemove or (mod:GetEntityData(entity).FrameAddedDichro and game:GetFrameCount() - mod:GetEntityData(entity).FrameAddedDichro < mod.DICHROMATIC_BUTTERFLY.LASER_HOMING_FRAMES) then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingDichroFlag, flag)

local checkingForRockets = {}
function mod:dichromaticFlagGeneric(entity, player, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.LASER and mod:GetEntityData(entity).FrameAddedDichro and
	   game:GetFrameCount() - mod:GetEntityData(entity).FrameAddedDichro < mod.DICHROMATIC_BUTTERFLY.LASER_HOMING_FRAMES
	then
		return
	end
	if weaponFlag == TearFlagsLib.WeaponFlag.KNIFE then return end
	if weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS then return end
	if weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT then return end

	if weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS then
		local target
		if mod.CurrentRocketTarget then
			target = mod.CurrentRocketTarget
		elseif #checkingForRockets > 0 then
			target = checkingForRockets[#checkingForRockets]
		end
		if target and TearFlagsLib.HasTearFlags(target, flag) then
			TearFlagsLib.AddTearFlags(entity, flag)
			mod:GetEntityData(entity).FFExplosionColor = TearFlagsLib.GetTearFlagParams(entity, flag).ExploColor or tearcolor
		end
	elseif player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) or player:HasTrinket(mod.ITEM.TRINKET.YIN_YANG_ORB) then
		local randval = 30
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) and player:HasTrinket(mod.ITEM.TRINKET.YIN_YANG_ORB) then
			randval = 20
		end
		local luck = math.max(math.min(math.floor(player.Luck), 7), -1)
		if math.random(randval) < 5 + (luck * 2) then
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
				if FiendFolio.HasCetusFlag(entity) then
					entity.Color = tearcolor
				else
					mod:changeTearVariant(entity, mod.TEAR.HOMING_AMULET, mod.TEAR.HOMING_AMULET_BLOOD)
					if FiendFolio.HasBeansFlag(entity) then
						entity.Color = tearcolor
					end
				end

				local tear = entity:ToTear()
				tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING

				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					local origDamage, origScale = tear.CollisionDamage, tear.Scale
					tear.CollisionDamage = origDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
					tear.Scale = origScale * (mod:getTearParamsScale(player, tear.CollisionDamage, tear.TearFlags) / mod:getTearParamsScale(player, origDamage, tear.TearFlags))
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				TearFlagsLib.SetTearFlagParams(entity, flag, {Strength = 0.4})

				mod:changeTearVariant(entity, mod.TEAR.HOMING_AMULET, mod.TEAR.HOMING_AMULET_BLOOD)
				if FiendFolio.HasBeansFlag(entity) then
					entity.Color = tearcolor
				end

				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					local tear = entity:ToTear()
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
					tear.CollisionDamage = tear.CollisionDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD then
				local tear = entity:ToTear()
				tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					mod.scheduleForUpdate(function()
						tear.CollisionDamage = (tear.CollisionDamage - 185) * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0)) + 185
					end, 1)
				end
				mod.scheduleForUpdate(function()
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
				end, 0)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				local tear = entity:ToTear()
				tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					mod.scheduleForUpdate(function()
						tear.CollisionDamage = (tear.CollisionDamage - 30) * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0)) + 30
					end, 1)
				end
				mod.scheduleForUpdate(function()
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
				end, 0)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS then
				entity.Color = tearcolor

				local bomb = entity:ToBomb()
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					bomb.ExplosionDamage = bomb.ExplosionDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
				end
				bomb.Flags = bomb.Flags | TearFlags.TEAR_HOMING
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
				if REPENTOGON.MeetsVersion("1.1.2") then
					entity:ToEffect():AddTearFlags(TearFlags.TEAR_HOMING)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER then
				mod:GetEntityData(entity).FrameAddedDichro = game:GetFrameCount()

				local laser = entity:ToLaser()
				laser:AddTearFlags(TearFlags.TEAR_HOMING)
				laser:SetHomingType(1125515264) -- ?????????
				laser:RecalculateSamplesNextUpdate()
			elseif weaponFlag == TearFlagsLib.WeaponFlag.CLUB then
				entity.Color = tearcolor
				entity:ToKnife():AddTearFlags(TearFlags.TEAR_HOMING)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.SWORD then
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					entity.CollisionDamage = entity.CollisionDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
				end
				entity.Color = tearcolor
				entity:ToKnife():AddTearFlags(TearFlags.TEAR_HOMING)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL then
				if REPENTOGON.MeetsVersion("1.1.2") then
					entity:ToEffect():AddTearFlags(TearFlags.TEAR_HOMING)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or
			       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
			       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
			then
				-- do nothing
			else
				entity.Color = tearcolor
				TearFlagsLib.AddCustomVanillaTearFlags(entity, TearFlags.TEAR_HOMING)
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					entity.CollisionDamage = entity.CollisionDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
				end
			end

			TearFlagsLib.AddTearFlags(entity, flag)
		end
	end
end
mod:AddPriorityCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, -350, mod.dichromaticFlagGeneric)

function mod:dichromaticFlagKnife(knife, player)
	-- this isn't how effects are usually polled for knives but i'll make an exception for a movement effect like this
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE) then
		local totalWeight = 0
		for i = 1, #mod.PRANK_COOKIE.EFFECTS do
			totalWeight = totalWeight + mod.PRANK_COOKIE.EFFECTS[i].Weight
		end

		local rand = math.random() * totalWeight
		local chosenEffect = nil
		for i = 1, #mod.PRANK_COOKIE.EFFECTS do
			if rand <= mod.PRANK_COOKIE.EFFECTS[i].Weight then
				chosenEffect = mod.PRANK_COOKIE.EFFECTS[i]
				break
			end
			rand = rand - mod.PRANK_COOKIE.EFFECTS[i].Weight
		end
		if chosenEffect == nil then
			chosenEffect = mod.PRANK_COOKIE.EFFECTS[#mod.PRANK_COOKIE.EFFECTS]
		end

		if chosenEffect.DataFlag == "YinYang" then
			if math.random(20) < 5 then
				TearFlagsLib.AddTearFlags(knife, TearFlagsLib.Flag.PRANK_COOKIE)
				TearFlagsLib.SetTearFlagParams(knife, TearFlagsLib.Flag.PRANK_COOKIE, {Effect = chosenEffect, NoRemove = true})

				TearFlagsLib.AddTearFlags(knife, flag)
				TearFlagsLib.SetTearFlagParams(knife, flag, {NoRemove = true})
				knife:AddTearFlags(TearFlags.TEAR_HOMING)
			end
		end
	end
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) or player:HasTrinket(mod.ITEM.TRINKET.YIN_YANG_ORB) then
		local randval = 30
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) and player:HasTrinket(mod.ITEM.TRINKET.YIN_YANG_ORB) then
			randval = 20
		end
		local luck = math.max(math.min(math.floor(player.Luck), 7), -1)
		if math.random(randval) < 5 + (luck * 2) then
			TearFlagsLib.AddTearFlags(knife, flag)
			TearFlagsLib.SetTearFlagParams(knife, flag, {NoRemove = true})
			knife:AddTearFlags(TearFlags.TEAR_HOMING)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	if TearFlagsLib.HasTearFlags(tear, flag) then
		local strength = TearFlagsLib.GetTearFlagParams(tear, flag).Strength or 0.3
		local chosenenemy
		local closestdist = 999
		for _,enemy in ipairs(Isaac.FindInRadius(tear.Position, 100, EntityPartition.ENEMY)) do
			if enemy:ToNPC() and not (enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) then
				if not mod:GetEntityData(tear).FFMultiEuclideanIgnoreEnemy
				or (mod:GetEntityData(tear).FFMultiEuclideanIgnoreEnemy and mod:GetEntityData(tear).FFMultiEuclideanIgnoreEnemy ~= enemy.InitSeed) then
					local vec = enemy.Position - tear.Position
					if vec:Length() < closestdist then
						chosenenemy = enemy
						closestdist = vec:Length()
					end
				end
			end
		end
		if chosenenemy then
			tear.Velocity = mod:Lerp(tear.Velocity, (chosenenemy.Position - tear.Position) * 0.3, strength)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	if TearFlagsLib.HasTearFlags(bomb, flag) then
		local strength = TearFlagsLib.GetTearFlagParams(bomb, flag).Strength or 0.3
		local chosenenemy
		local closestdist = 999
		for _,enemy in ipairs(Isaac.FindInRadius(bomb.Position, 100, EntityPartition.ENEMY)) do
			if enemy:ToNPC() and not (enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) then
				if not mod:GetEntityData(bomb).FFMultiEuclideanIgnoreEnemy
				or (mod:GetEntityData(bomb).FFMultiEuclideanIgnoreEnemy and mod:GetEntityData(bomb).FFMultiEuclideanIgnoreEnemy ~= enemy.InitSeed) then
					local vec = enemy.Position - bomb.Position
					if vec:Length() < closestdist then
						chosenenemy = enemy
						closestdist = vec:Length()
					end
				end
			end
		end
		if chosenenemy then
			bomb.Velocity = mod:Lerp(bomb.Velocity, (chosenenemy.Position - bomb.Position) * 0.3, strength)
		end
	end
end)

function mod:handleAquariusDichroDamage(creep)
	if TearFlagsLib.HasTearFlags(creep, flag) then
		local player = TearFlagsLib.GetTearPlayer(creep)
		if player then
			creep.CollisionDamage = creep.CollisionDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, creep)
	if TearFlagsLib.HasTearFlags(creep, flag) then
		local strength = TearFlagsLib.GetTearFlagParams(creep, flag).Strength or 0.3
		local chosenenemy
		local closestdist = 999
		for _,enemy in ipairs(Isaac.FindInRadius(creep.Position, 100, EntityPartition.ENEMY)) do
			if enemy:ToNPC() and not (enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) then
				local vec = enemy.Position - creep.Position
				if vec:Length() < closestdist then
					chosenenemy = enemy
					closestdist = vec:Length()
				end
			end
		end
		if chosenenemy then
			creep.Velocity = mod:Lerp(creep.Velocity, (chosenenemy.Position - creep.Position) * 0.3, strength)
		end
	end
end, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, math.huge, function(_, target)
	table.insert(checkingForRockets, target)
end, EffectVariant.TARGET)

mod:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, -1 * math.huge, function(_, target)
	for i = #checkingForRockets, 1, -1 do
		local entity = checkingForRockets[i]
		table.remove(checkingForRockets, i)
		if GetPtrHash(target) == GetPtrHash(entity) then
			break
		end
	end
end, EffectVariant.TARGET)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, target)
	if not target:Exists() then return end

	-- this isn't how rocket effects are rolled for most items but i figured the old method would be appropriate for something that homes
	-- especially since the target does indeed handle the homing effect normally
	local data = mod:GetEntityData(target)
	if not data.RolledForPrankCookie then
		local player = TearFlagsLib.GetTearPlayer(target)
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE) then
			local totalWeight = 0
			for i = 1, #mod.PRANK_COOKIE.EFFECTS do
				totalWeight = totalWeight + mod.PRANK_COOKIE.EFFECTS[i].Weight
			end

			local rand = math.random() * totalWeight
			local chosenEffect = nil
			for i = 1, #mod.PRANK_COOKIE.EFFECTS do
				if rand <= mod.PRANK_COOKIE.EFFECTS[i].Weight then
					chosenEffect = mod.PRANK_COOKIE.EFFECTS[i]
					break
				end
				rand = rand - mod.PRANK_COOKIE.EFFECTS[i].Weight
			end
			if chosenEffect == nil then
				chosenEffect = mod.PRANK_COOKIE.EFFECTS[#mod.PRANK_COOKIE.EFFECTS]
			end

			if chosenEffect.DataFlag == "YinYang" then
				TearFlagsLib.AddTearFlags(target, TearFlagsLib.Flag.PRANK_COOKIE)
				TearFlagsLib.SetTearFlagParams(target, TearFlagsLib.Flag.PRANK_COOKIE, {Effect = chosenEffect})

				if math.random(20) < 5 then
					TearFlagsLib.AddTearFlags(target, flag)
					TearFlagsLib.SetTearFlagParams(target, flag, {ExploColor = chosenEffect.Color})
				end
			end
		end
		data.RolledForPrankCookie = true
	end
	if not data.RolledForYinYang then
		local player = TearFlagsLib.GetTearPlayer(target)
		if player and (player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) or player:HasTrinket(mod.ITEM.TRINKET.YIN_YANG_ORB)) then
			local randval = 30
			if player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) and player:HasTrinket(mod.ITEM.TRINKET.YIN_YANG_ORB) then
				randval = 20
			end
			local luck = math.max(math.min(math.floor(player.Luck), 7), -1)
			if math.random(randval) < 5 + (luck * 2) then
				TearFlagsLib.AddTearFlags(target, flag)
			end
		end
		data.RolledForYinYang = true
	end

	if not (data.beeSkinTarget or data.InabaFollowIndex or data.binabaFetusRocket or target.SubType == 4) and TearFlagsLib.HasTearFlags(target, flag) then
		local strength = TearFlagsLib.GetTearFlagParams(target, flag).Strength or 0.3
		local chosenenemy
		local closestdist = 999
		for _,enemy in ipairs(Isaac.FindInRadius(target.Position, 100, EntityPartition.ENEMY)) do
			if enemy:ToNPC() and not (enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) then
				local vec = enemy.Position - target.Position
				if vec:Length() < closestdist then
					chosenenemy = enemy
					closestdist = vec:Length()
				end
			end
		end
		if chosenenemy then
			target.Velocity = mod:Lerp(target.Velocity, (chosenenemy.Position - target.Position) * 0.5, strength)
		end
	end
end, EffectVariant.TARGET)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	if source.Type ~= 1000 or (source.Variant ~= EffectVariant.TECH_DOT and source.Variant ~= EffectVariant.BRIMSTONE_SWIRL) or not source.Entity or
	   not TearFlagsLib.HasTearFlags(source.Entity, flag)
	then
		return
	end

	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if player then
		return {Damage = amount * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	if source.Type ~= 1000 or (source.Variant ~= EffectVariant.ROCKET and source.Variant ~= EffectVariant.SMALL_ROCKET) or not source.Entity or
	   not TearFlagsLib.HasTearFlags(source.Entity, flag)
	then
		return
	end

	if flags & DamageFlag.DAMAGE_EXPLOSION > 0 then
		local player = TearFlagsLib.GetTearPlayer(source.Entity)
		if player then
			return {Damage = amount * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))}
		end
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	if extraSource == nil or extraSource.Type ~= 3 or extraSource.Variant ~= FamiliarVariant.UMBILICAL_BABY or not extraSource.Entity or
	   not TearFlagsLib.HasTearFlags(extraSource.Entity, flag)
	then
		return
	end

	local player = TearFlagsLib.GetTearPlayer(extraSource.Entity)
	if player then
		return {Damage = amount * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	local source = extraSource or source
	if source.Entity and TearFlagsLib.IsEntitySpiritSword(source.Entity) then
		return
	end
	if source.Type ~= 8 or not source.Entity or
	   not TearFlagsLib.HasTearFlags(source.Entity, flag)
	then
		return
	end

	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if player then
		return {Damage = amount * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	local source = extraSource or source
	if (source.Type ~= EntityType.ENTITY_LASER and not (source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.BRIMSTONE_BALL)) or not source.Entity or
	   not TearFlagsLib.HasTearFlags(source.Entity, flag)
	then
		return
	end

	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if player then
		return {Damage = amount * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local source = extraSource or source
	if not (source.Type == 1 and TearFlagsLib.hemoptysisDummy and TearFlagsLib.HasTearFlags(TearFlagsLib.hemoptysisDummy, flag)) then 
		return 
	end

	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if player then
		return {Damage = amount * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	local source = extraSource or source
	local hitter = nil
	if source.Type == 0 and flags & DamageFlag.DAMAGE_LASER > 0 then
		local potential = mod.CheckingForDmg[#mod.CheckingForDmg]
		if potential and TearFlagsLib.IsEntityOcularRift(potential) then
			hitter = potential
		end
	elseif source.Entity and TearFlagsLib.IsEntityOcularRift(source.Entity) then
		hitter = source.Entity
	elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.DARK_SNARE and source.Entity and source.Entity.SpawnerEntity then
		hitter = source.Entity
	else
		return
	end
	if hitter == nil then return end

	-- this is technically not accurate for ocular rift since it rolls every hit instead of every frame but idc
	-- this functions nicer for can of beans purposes
	-- i'll leave tearflagslib generally as it is but for weird stuff like this imma do this instead
	local player = TearFlagsLib.GetTearPlayer(hitter)
	if not player then return end

	local data = mod:GetEntityData(hitter)
	local frame = game:GetFrameCount()
	if data.RolledForDichro ~= frame and data.AppliedDichro ~= frame then
		TearFlagsLib.SetTearFlagParams(hitter, flag, {NoRemove = false})
		TearFlagsLib.ClearTearFlags(hitter, flag)
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) or player:HasTrinket(mod.ITEM.TRINKET.YIN_YANG_ORB) then
			local randval = 30
			if player:HasCollectible(mod.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY) and player:HasTrinket(mod.ITEM.TRINKET.YIN_YANG_ORB) then
				randval = 20
			end
			local luck = math.max(math.min(math.floor(player.Luck), 7), -1)
			if math.random(randval) < 5 + (luck * 2) then
				TearFlagsLib.AddTearFlags(hitter, flag)
				TearFlagsLib.SetTearFlagParams(hitter, flag, {NoRemove = true})
				data.AppliedDichro = frame
			end
		end
		data.RolledForDichro = frame
	end
	if TearFlagsLib.HasTearFlags(hitter, flag) then
		return {Damage = amount * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))}
	end
end)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY] = {
	BodyColor = Color(1,1,1,1,0,0,0,199/255,10/255,10/255,1),
	EyeAColor = Color(1,1,1,1,0,0,0,255/255,255/255,255/255,1),
	EyeBColor = Color(1,1,1,1,0,0,0,51/255,51/255,51/255,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random(30) < 5 then
		mod:changeTearVariant(tear, mod.TEAR.HOMING_AMULET, mod.TEAR.HOMING_AMULET_BLOOD)

		local player = familiar.Player
		TearFlagsLib.AddTearFlags(tear, flag)
		tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING

		local origDamage, origScale = tear.CollisionDamage, tear.Scale
		tear.CollisionDamage = origDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
		tear.Scale = origScale * (mod:getTearParamsScale(player, tear.CollisionDamage, tear.TearFlags) / mod:getTearParamsScale(player, origDamage, tear.TearFlags))
	end
end, FiendFolio.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY)

function mod:homingAmuletTearRender(tear, var, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags

	local prefix = "Regular"
	if tear.Variant == mod.TEAR.HOMING_AMULET_BLOOD then
		prefix = "Blood"
	end

	local anim
	if scale <= 0.3 then
		anim = prefix .. "Tear1"
	elseif scale <= 0.55 then
		anim = prefix .. "Tear2"
	elseif scale <= 0.675 then
		anim = prefix .. "Tear3"
	elseif scale <= 0.8 then
		anim = prefix .. "Tear4"
	elseif scale <= 0.925 then
		anim = prefix .. "Tear5"
	elseif scale <= 1.05 then
		anim = prefix .. "Tear6"
	elseif scale <= 1.175 then
		anim = prefix .. "Tear7"
	elseif scale <= 1.425 then
		anim = prefix .. "Tear8"
	elseif scale <= 1.675 then
		anim = prefix .. "Tear9"
	elseif scale <= 1.925 then
		anim = prefix .. "Tear10"
	elseif scale <= 2.175 then
		anim = prefix .. "Tear11"
	elseif scale <= 2.55 then
		anim = prefix .. "Tear12"
	else
		anim = prefix .. "Tear13"
	end

	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale13(tear)
	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(spritescale)
	end

	local adjustedVelocity = tear.Velocity
	if tear.WaitFrames > 0 then
		adjustedVelocity = tear.ContinueVelocity
	elseif (tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed) and
	       flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and
	       ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1)
	then
		adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
	end

	sprite.Rotation = adjustedVelocity:GetAngleDegrees()
	sprite.FlipX = false
	sprite.FlipY = false
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.homingAmuletTearRender, FiendFolio.TEAR.HOMING_AMULET)
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.homingAmuletTearRender, FiendFolio.TEAR.HOMING_AMULET_BLOOD)

function mod:homingAmuletTearSplat(tear, var, data)
	sfx:Play(SoundEffect.SOUND_SPLATTER, 1, 0, false, 1.0)

	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale
	local color = tear:GetSprite().Color

	if tear.Variant == mod.TEAR.HOMING_AMULET_BLOOD then
		local poof = Isaac.Spawn(1000, EffectVariant.BULLET_POOF, 0, tear.Position, Vector.Zero, tear)
		poof:GetSprite().Color = color
		poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
		poof.PositionOffset = tear.PositionOffset
	else
		local poof = Isaac.Spawn(1000, mod:getNormalTearPoofVariant(tear.Scale, tear.Height), 0, tear.Position, Vector.Zero, tear)
		poof:GetSprite().Color = color
		if scale > 0.8 then
			poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
		end
		poof.PositionOffset = tear.PositionOffset
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.homingAmuletTearSplat, FiendFolio.TEAR.HOMING_AMULET)
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.homingAmuletTearSplat, FiendFolio.TEAR.HOMING_AMULET_BLOOD)