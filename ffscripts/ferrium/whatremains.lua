local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--[[mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local sprite = proj:GetSprite()
	local data = mod:GetEntityData(proj)
	--mod:PrintColor(proj.Color)

	print(sprite:GetAnimation())
end)]]

--[[function mod:printTears(npc)
	local sprite = npc:GetSprite()
	--print(npc.Variant)
	--mod:PrintColor(npc:GetColor())
	--print(npc:GetSprite():GetFilename())
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.printTears)]]

--[[function mod:forTestStuffEnemies(npc)
	local data = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()
	--print(npc.State)
	print(npc:GetEntityFlags())
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.forTestStuffEnemies)]]

--[[mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, v)
	print(v:GetSprite():GetAnimation())
end)]]

function mod.throwShit(pos, vel, z_init, z_vel, spawner, state, countdown, damage) -- Shamelessly stealing the throw maggot code to see if it works cause I don't understand editing basegame stuff
	local rSpider
	local forceSplat
	local bounce
	if state == "coalSpider" then
		rSpider = Isaac.Spawn(818, 2, mod:RandomInt(1,3), pos, vel, spawner):ToNPC()
		forceSplat = mod.ColorFireyFade
		bounce = z_vel*0.3
	elseif state == "rockSpider" then
		rSpider = Isaac.Spawn(818, 0, mod:RandomInt(1,3), pos, vel, spawner):ToNPC()
		bounce = z_vel*0.3
	elseif state == "coal" then
		rSpider = Isaac.Spawn(33, 11, mod:RandomInt(1,3), pos, vel, spawner):ToNPC()
		rSpider.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		forceSplat = mod.ColorFireyFade
		bounce = z_vel*0.3
	elseif state == "redBomb" then
		rSpider = Isaac.Spawn(4, 13, 114, pos, vel, spawner):ToBomb()
		rSpider.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		rSpider.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		if countdown then
			rSpider:SetExplosionCountdown(countdown)
		end
		if damage then
			rSpider.ExplosionDamage = damage
		end
		rSpider.PositionOffset = Vector(0,z_init)
		rSpider.Parent = spawner
		mod:GetEntityData(rSpider).playerGrab = true
	elseif state == "rottenGaper" then
		local sType = countdown or 0
		rSpider = Isaac.Spawn(10, 3, sType, pos, vel, spawner):ToNPC()
	end
	
	if state ~= "redBomb" and state ~= "rottenGaper" then
		rSpider.State = 16
		rSpider:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	elseif state == "rottenGaper" then
		rSpider:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
	--rSpider.PositionOffset = Vector(0, z_init)

	local data = mod:GetEntityData(rSpider)
	--leaving this bit here since don't want to mess with the red bomb stuff
	data.isthrown = true
	data.z_vel = z_vel
	data.forcevel = vel
	if forceSplat then
		data.forceSplatColor = forceSplat
	end
	data.launchedEnemyInfo = {zVel = z_vel, height = z_init, collision = -30}
	data.launchedEnemyInfo.vel = vel
	if bounce then 
		data.launchedEnemyInfo.landFunc = function(npc, tab)
			data.launchedEnemyInfo = {zVel = bounce, vel = vel, landFunc = function() data.launchedEnemyInfo = {zVel = bounce*0.5, vel = vel*0.5} end}
		end
	end
	--data.launchedEnemyInfo.pos = true

	return rSpider
end

--[[mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local data = mod:GetEntityData(npc)
	if data.isthrown then
		if data.z_vel < 0 then
			npc.PositionOffset = Vector(0, npc.PositionOffset.Y + data.z_vel)
			data.z_vel = data.z_vel + 1
			npc.Position = npc.Position + data.forcevel
		end
	end
end, 818)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local data = mod:GetEntityData(npc)
	if data.isthrown then
		if data.z_vel < 0 then
			npc.PositionOffset = Vector(0, npc.PositionOffset.Y + data.z_vel)
			data.z_vel = data.z_vel + 1
			npc.Position = npc.Position + data.forcevel
		end
	end
end, 33)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local data = mod:GetEntityData(npc)
	if data.isthrown then
		if npc.PositionOffset.Y < 0 or data.z_vel < 0 then
			npc.PositionOffset = Vector(0, npc.PositionOffset.Y + data.z_vel)
			data.z_vel = data.z_vel + 1
			npc.Position = npc.Position + data.forcevel
		end
	end
end, 10)]]

function mod:destroyTheDangPoof(effect)
	if effect.SpawnerEntity and mod:GetEntityData(effect.SpawnerEntity).removePoof == true then
		effect.Visible = false
		effect:Update()
		effect:Remove()
		mod:GetEntityData(effect.SpawnerEntity).removePoof = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.destroyTheDangPoof, 15)

function mod:superExists(npc)
	if npc and npc:ToNPC() then
		if npc and npc:Exists() and not mod:isStatusCorpse(npc) and not npc:IsDead() then
			return true
		else
			return false
		end
	else
		if npc and npc:Exists() then
			return true
		else
			return false
		end
	end
end

function mod:findActiveSlot(num, player)
	for i=0,2 do
		if player:GetActiveItem(i) == num then
			return i
		end
	end
end

function mod:ferriumCommands(cmd, params)
	if cmd == "reviveme" or cmd == "revive" then
		for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1)
			local isPlayingDeathAnimation = player:GetSprite():GetAnimation():sub(-#"Death") == "Death"
			if isPlayingDeathAnimation then
				if not params or not tonumber(params) then
					params = 6
				end
				mod:GetEntityData(player).pleasegivemethisonechanceitwasunfairdamage = math.floor(params)
			end
		end
	end
end

function mod.CheckReviveMeCommandRevive(player, data)
	if data.pleasegivemethisonechanceitwasunfairdamage then
		player:Revive()
		player:SetMinDamageCooldown(60)

		local healthtoadd = data.pleasegivemethisonechanceitwasunfairdamage - player:GetHearts() - player:GetSoulHearts()
		data.pleasegivemethisonechanceitwasunfairdamage = nil

		if healthtoadd > 0 then
			local maxhearts = player:GetMaxHearts()
			if maxhearts > 0 then
				local overflow = healthtoadd - maxhearts + player:GetHearts()
				player:AddHearts(healthtoadd)
				if overflow > 0 then
					player:AddSoulHearts(overflow)
				end
			else
				player:AddSoulHearts(healthtoadd)
			end
		end
	end
end

function mod.dontHitImmediatelyTear(v, d)
	if d.dontHitImmediately then
		if d.dontHitImmediately > 0 then
			d.dontHitImmediately = d.dontHitImmediately-1
			v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		else
			v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			d.dontHitImmediately = nil
		end
	end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local d = mod:GetEntityData(fam)
	if d.IgnoreForAMoment then
		if d.IgnoreForAMoment > 0 then
			fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			fam.Target = fam.Player
			d.IgnoreForAMoment = d.IgnoreForAMoment-1
		else
			d.IgnoreForAMoment = nil
			fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
		end
	end
end, FamiliarVariant.BLUE_FLY)

function mod:IsGlobinSpritesheet(npc)
	local sprite = npc:GetSprite()
	if sprite:GetFilename() == "gfx/024.000_Globin.anm2" then
		return true
	end
end

function mod:GetSimpleAimDir(player)
	--[[local dir = player:GetAimDirection()
    local lockAngle
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) and 1 == 0 then
            lockAngle = 45
        else
            lockAngle = 90
        end
    end
    if lockAngle then
        dir = mod:SnapVector(dir, lockAngle)
    end]]
	local dir = mod.GetCorrectedFiringInput(player) --Commented out above just in case
	return Vector(dir.X, dir.Y)
end

function mod:isDamageSelfInflicted(flag, source, ignoreCurse, letPickupsHurt)
	if not (letPickupsHurt and source and source.Type == 5) then
		if ignoreCurse and flag == flag | DamageFlag.DAMAGE_CURSED_DOOR then
			return false
		else
			return flag == flag | DamageFlag.DAMAGE_FAKE or flag == flag | DamageFlag.DAMAGE_NO_PENALTIES or flag == flag | DamageFlag.DAMAGE_IV_BAG or (source and source.Type == EntityType.ENTITY_SLOT) or flag == flag | DamageFlag.DAMAGE_INVINCIBLE or (source.Type == 0 and source.Variant == 10003)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_ITEMS, function(_, chance)
	local add = 0
    for i=1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		local d = mod:GetEntityData(p).ffsavedata.RunEffects
		if d.PlanetariumChanceTemporary then --Grants for one floor
			add = add+d.PlanetariumChanceTemporary
			d.PlanetariumChanceTemporary = nil
		end
		if d.PlanetariumChanceSemiPermanent then --Permanent until a Planetarium shows up
			add = add+d.PlanetariumChanceSemiPermanent
			local rooms = game:GetLevel():GetRooms()
			for j=1,rooms.Size do
				local room = rooms:Get(j)
				if room and room.Data.Type == RoomType.ROOM_PLANETARIUM then
					d.PlanetariumChanceSemiPermanent = nil
					break
				end
			end
		end
		if d.PlanetariumChancePermanent then --Stays for the whole run
			add = add+d.PlanetariumChancePermanent
		end

	end
	if add > 0 then
	    return chance + add
	end
end)



--Can put in either the actual variant, or the pickup itself
function mod:IsPickupAHeart(info)
	if not type(info) == "number" then
		info = info.Variant
	end
	return mod.HeartVariants[info]
end

local SoulVariants = {
	[FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART] = 1,
	[FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART] = 2,
	[FiendFolio.PICKUP.VARIANT.IMMORAL_HEART] = 2,
	[FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART] = 1,
}

function mod:IsSoulHeartPickup(var, subtype)
	if mod.HeartVariants[var] then
		if SoulVariants[var] then
			return SoulVariants[var]
		elseif var == PickupVariant.PICKUP_HEART then
			if subtype == HeartSubType.HEART_SOUL or subtype == HeartSubType.HEART_BLACK or subtype == HeartSubType.HEART_BLENDED then
				return 2
			elseif subtype == HeartSubType.HEART_HALF_SOUL then
				return 1
			end
		end
	end
end

function mod:StopFFPlayerSoundsIGuess(player)
	mod.scheduleForUpdate(function()
		if player:GetPlayerType() == mod.PLAYER.FIEND or player:GetPlayerType() == mod.PLAYER.CHINA or player:GetPlayerType() == mod.PLAYER.CLASSIC_FIEND then
			if sfx:IsPlaying(mod.Sounds.FiendHurt) then
				sfx:Stop(mod.Sounds.FiendHurt)
			end
		elseif player:GetPlayerType() == mod.PLAYER.BIEND then
			if sfx:IsPlaying(mod.Sounds.BiendHurt) then
				sfx:Stop(mod.Sounds.BiendHurt)
			end
		elseif player:GetPlayerType() == mod.PLAYER.GOLEM or player:GetPlayerType() == mod.PLAYER.BOLEM then
			if sfx:IsPlaying(mod.Sounds.GolemHurt) then
				sfx:Stop(mod.Sounds.GolemHurt)
			end
		elseif player:GetPlayerType() == mod.PLAYER.CRAIG then
			if sfx:IsPlaying(mod.Sounds.CraigHurt) then
				sfx:Stop(mod.Sounds.CraigHurt)
			end
		elseif player:GetPlayerType() == mod.PLAYER.FRIEND or player:GetPlayerType() == mod.PLAYER.BRIEND then
			if sfx:IsPlaying(mod.Sounds.FriendHurt) then
				sfx:Stop(mod.Sounds.FriendHurt)
			end
		elseif player:GetPlayerType() == mod.PLAYER.INABA or player:GetPlayerType() == mod.PLAYER.BINABA then
			if sfx:IsPlaying(mod.Sounds.InabaHurt) then
				sfx:Stop(mod.Sounds.InabaHurt)
			end
		end
	end, 0)
end

function mod:GetDirtColor(Position)
	local dirt = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PILE, 0, Position, Vector.Zero, nil)
	dirt.Visible = false
	dirt:Update()
	local color = dirt:GetSprite().Color
	dirt:Remove()
	return color
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
	if collider.Type == EntityType.ENTITY_PLAYER and collider:ToPlayer():CanPickupItem() then
		local d = mod:GetEntityData(pickup)
		d.CheckForNewBomb = true
		mod.scheduleForUpdate(function()
			d.CheckForNewBomb = false
		end, 3)
	end
end, PickupVariant.PICKUP_THROWABLEBOMB)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bomb)
	if bomb.SpawnerEntity and bomb.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
		for _,check in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_THROWABLEBOMB, -1, false, false)) do
			if check.Position:Distance(bomb.Position) < 5 and mod:GetEntityData(check).CheckForNewBomb then
				local d = mod:GetEntityData(bomb)
				local origData = mod:GetEntityData(check)
				if origData.TransferRedBombDataTable then
					for key,entry in pairs(origData.TransferRedBombDataTable) do
						if type(entry) == "table" then
							d[key] = mod:makeCopiedTable(entry)
						else
							d[key] = entry
						end
					end
				end
			end
		end
	end
end, BombVariant.BOMB_THROWABLE)