local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local flagsManager = TearFlagsLib

local spinchColor = Color(0.5, 1.5, 0.5, 1, 0, 0, 0)
spinchColor:SetColorize(0.5, 1, 0.5, 1)
local spinchColorLaser = Color(1, 1, 1, 1, 0, 0, 0)
spinchColorLaser:SetColorize(1.6, 3.3, 1.2, 1)
local spinchColorEff = Color(0, 1, 1, 1, 0, 0.5, 0)
spinchColorEff:SetColorize(1, 1, 1, 1)

local creepDamageDivider = 14
local flag = TearFlagsLib.RegisterTearFlag("SPINACH")

function mod:preventRemovingSpinachFlag(entity, player, flag)
	local params = TearFlagsLib.GetTearFlagParams(entity, flag)
	if params.NoRemove then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.preventRemovingSpinachFlag, flag)

function mod:spinachLaserColor(player, flag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SPINACH_PIE) then
		player.LaserColor = player.LaserColor * spinchColorLaser
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.SPINACH_PIE, mod.spinachLaserColor, CacheFlag.CACHE_TEARCOLOR)

local function canFireSpinachPie(player, rng)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.SPINACH_PIE) then
        local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SPINACH_PIE)
		local chance = 15*mult+mod.XalumLuckBonus(player.Luck, 20, 0.3)*100
        rng = rng or player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SPINACH_PIE)
		if rng:RandomInt(100) < chance then
            return true
        end
    end
end

function spawnVomSplurt(player, vel)
    local rng = player:GetDropRNG()
    sfx:Play(mod.Sounds.Valvo,0.5,2,false,mod:RandomInt(125,150,rng)/100)
    sfx:Play(mod.Sounds.WaterSwish,0.5,2,false,mod:RandomInt(150,170,rng)/100)
    local shootVec = vel:Resized(player.ShotSpeed * 100)
    local d = mod:GetEntityData(player)
    for i = 1, mod:RandomInt(1,3,rng) do
        local targetposition = player.Position + shootVec + mod:TrueRandomVector(rng):Resized(mod:RandomInt(10,30,rng))
        local effect = Isaac.Spawn(1000, EffectVariant.BLOOD_DROP, 0, player.Position, (targetposition-player.Position):Resized(10*0.2+mod:getRoll(30,55,rng)/10):Rotated(mod:getRoll(-30,30,rng)), player):ToEffect()
        effect.Color = spinchColorEff
        effect.Scale = 0.5
        effect.PositionOffset = Vector(0, -20-mod:RandomInt(1, 10,rng))
        effect:Update()
        effect.FallingSpeed = -mod:getRoll(6,10,rng)
    end
end

function mod:spawnSpinachCreep(ent, pos, scale, damage, player)
	local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_GREEN, 0, pos, Vector.Zero, player):ToEffect()
	creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
	creep.Scale = (scale or creep.Scale) * mod:RandomInt(75,150)/100
	creep.CollisionDamage = damage
	creep:Update()
	
	creep.Scale = creep.Size / 20
	creep.SpriteScale = Vector(1,1) * creep.Scale
	if 42 <= creep.Size then
		creep:GetSprite():SetFrame("BiggestBlood0"..math.random(6), 0)
		creep.Scale = creep.Scale * 28/88
		creep.SpriteScale = creep.SpriteScale * 28/88
	elseif 26 <= creep.Size then
		creep:GetSprite():SetFrame("BigBlood0"..math.random(6), 0)
		creep.Scale = creep.Scale * 28/44
		creep.SpriteScale = creep.SpriteScale * 28/44
	elseif 19.8 <= creep.Size then
		creep:GetSprite():SetFrame("Blood0"..math.random(6), 0)
	else
		creep:GetSprite():SetFrame("SmallBlood0"..math.random(6), 0)
		creep.Scale = creep.Scale * 28/22
		creep.SpriteScale = creep.SpriteScale * 28/22
	end
end

function mod:spinachFlagGeneric(entity, player, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.KNIFE then return end
	
	if canFireSpinachPie(player) then
		TearFlagsLib.AddTearFlags(entity, flag)
		
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
            spawnVomSplurt(player, entity.Velocity)
			entity.Color = spinchColor
		elseif weaponFlag == TearFlagsLib.WeaponFlag.CLUB then
			mod.scheduleForUpdate(function()
				local capsulePosition, capsuleRadius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(entity)
				mod:spawnSpinachCreep(entity, capsulePosition, math.max(0.2, (math.random() * 1/6 + 4/3) * capsuleRadius / 32), entity.CollisionDamage / creepDamageDivider, player)
			end, 3)
			entity.Color = spinchColor
		elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
			mod:GetEntityData(entity).FFAquariusTearColor = spinchColor
		elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
			mod:GetEntityData(entity).FFExplosionColor = spinchColor
		elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
		       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
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
			entity.Color = spinchColor
		end
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.SPINACH_PIE, mod.spinachFlagGeneric)

function mod:spinachFlagKnife(knife, player)
	-- this isn't how effects are usually polled for knives but i'll make an exception for this
	if canFireSpinachPie(player) then
		TearFlagsLib.AddTearFlags(knife, flag)
		TearFlagsLib.SetTearFlagParams(knife, flag, {NoRemove = true})
	end
end

function mod:updateSpinachEffect(ent)
	if TearFlagsLib.HasTearFlags(ent, flag) then
		local player = TearFlagsLib.GetTearPlayer(ent)
		if player and (mod.playerCreepCount and mod.playerCreepCount < 100 or ent.FrameCount % 3 == 0) then
			local typ = ent.Type
			if ent.Type == EntityType.ENTITY_KNIFE then
				if ent:IsFlying() then
					local size = ent.Size / 20.0
					if not TearFlagsLib.IsKnifeSwingable(ent) then
						size = size * 2
					end
					mod:spawnSpinachCreep(ent, ent.Position, math.max(0.2, size), ent.CollisionDamage / creepDamageDivider, player)
				end
			elseif ent.Type == EntityType.ENTITY_EFFECT then
				if ent.Variant == EffectVariant.SMALL_ROCKET then
					mod:spawnSpinachCreep(ent, ent.Position, 0.8, player.Damage / creepDamageDivider, player)
				elseif ent.Variant == EffectVariant.TECH_DOT then
					mod:spawnSpinachCreep(ent, ent.Position, 0.33 * math.max(ent.SpriteScale.X, ent.SpriteScale.Y), player.Damage / creepDamageDivider, player)
				elseif ent.Variant == EffectVariant.BRIMSTONE_SWIRL then
					mod:spawnSpinachCreep(ent, ent.Position, 30 * ent.SpriteScale.X * ent:GetSprite():GetLayerFrameData(0):GetScale().X / 20, player.Damage / creepDamageDivider, player)
				else
					mod:spawnSpinachCreep(ent, ent.Position, math.max(0.2, ent.Size / 20.0), player.Damage / creepDamageDivider, player)
				end
			elseif ent.Type == EntityType.ENTITY_TEAR then
				mod:spawnSpinachCreep(ent, ent.Position, math.max(0.2, ent.Scale - 0.5), ent.CollisionDamage / creepDamageDivider, player)
			elseif ent.Type == EntityType.ENTITY_BOMB then
				mod:spawnSpinachCreep(ent, ent.Position, math.max(0.2, ent.Size / 20.0), ent.ExplosionDamage / creepDamageDivider, player)
			else
				mod:spawnSpinachCreep(ent, ent.Position, math.max(0.2, ent.Size / 20.0), ent.CollisionDamage / creepDamageDivider, player)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.updateSpinachEffect)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.updateSpinachEffect)
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.updateSpinachEffect)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.updateSpinachEffect, EffectVariant.SMALL_ROCKET)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.updateSpinachEffect, EffectVariant.TECH_DOT)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.updateSpinachEffect, EffectVariant.BRIMSTONE_SWIRL)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.updateSpinachEffect, EffectVariant.BRIMSTONE_BALL)

function mod:spinachTearDeath(tear)
	if TearFlagsLib.HasTearFlags(tear, flag) and not tear:HasTearFlags(TearFlags.TEAR_EXPLOSIVE) then
		mod:spawnSpinachCreep(tear, tear.Position, math.max(0.2, (tear.Scale - 0.5) * 2), tear.CollisionDamage / creepDamageDivider)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.spinachTearDeath)

function mod:spinachExplode(pos, damage, radius, lineCheck, source, tearflags, damageflags, damageSource)
	-- id do this in tearflags but that seems to have a stupid radius for ipecac
	if source and TearFlagsLib.HasTearFlags(source, flag) then
		local player = TearFlagsLib.GetTearPlayer(source)
		if player then
			mod:spawnSpinachCreep(source, pos, math.max(0.2, radius / 20), damage / creepDamageDivider, player)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_DAMAGE, mod.spinachExplode)

function mod:spinachSword(sword)
	if sword.SubType == 4 or not TearFlagsLib.IsEntitySpiritSword(sword) then return end
	
	if sword:GetIsSwinging() then
		if TearFlagsLib.HasTearFlags(sword, flag) then
			local player = TearFlagsLib.GetTearPlayer(sword)
			if player then
				local capsule = mod:getSwordCapsules(sword)
				local capsuleStart, capsuleEnd = capsule:GetVec2(), capsule:GetVec3()
				local dir = capsuleStart - capsuleEnd
				local dist = dir:Length()
				if dist > 0 then
					local distRemaining = dist + capsule:GetF1() * 2
					while distRemaining > 0 do
						mod:spawnSpinachCreep(sword, capsuleEnd + dir:Resized(dist - distRemaining + capsule:GetF1()), 0.75, sword.CollisionDamage / creepDamageDivider, player)
						distRemaining = distRemaining - 20
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.spinachSword)

function mod:handleAquariusSpinachDamage(creep)
	if TearFlagsLib.HasTearFlags(creep, flag) then
		local player = TearFlagsLib.GetTearPlayer(creep)
		if player then
			creep.CollisionDamage = creep.CollisionDamage + player.Damage / creepDamageDivider
		end
	end
end

function mod:spinachLaser(laser)
	local hasSpinach = TearFlagsLib.HasTearFlags(laser, flag)
	local data = mod:GetEntityData(laser)
	if hasSpinach and (laser.FrameCount <= 1 or not laser.OneHit) and not data.DidSpinachOneShot then
		local player = TearFlagsLib.GetTearPlayer(laser)
		if player and (mod.playerCreepCount and mod.playerCreepCount < 100 or laser.FrameCount % 3 == 0) then
			local samples = TearFlagsLib.GetLaserSampleCapsules(laser)
			local distToUse = 0
			local creepScale = math.max(0.2, laser.Size / 20)
			for _, sample in ipairs(samples) do
				local locus1 = sample.Locus1
				local locus2 = sample.Locus2
				local distRemaining = locus1:Distance(locus2)
				local usedDist = 0
				while (distRemaining > 0) do
					local distUsing = math.min(distToUse, distRemaining)
					usedDist = usedDist + distUsing
					distRemaining = distRemaining - distUsing
					distToUse = distToUse - distUsing
					if distToUse <= 0 then
						mod:spawnSpinachCreep(laser, locus1 + (locus2 - locus1):Resized(usedDist), creepScale, laser.CollisionDamage / creepDamageDivider, player)
						distToUse = distToUse + creepScale * 20
					end
				end
				data.DidSpinachOneShot = laser.OneHit
			end
		end
	end
	if not hasSpinach then
		data.DidSpinachOneShot = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.spinachLaser)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.SPINACH_PIE] = {
	BodyColor = Color(1,1,1,1,-13.969/255,-90.797/255,-12.547/255,1.031,1.203,0.453,1),
	EyeAColor = Color(1,1,1,1,-38.398/255,-19.735/255,-41.142/255,0.531,0.646,0.522,1),
	EyeBColor = Color(1,1,1,1,-38.398/255,-19.735/255,-41.142/255,0.531,0.646,0.522,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	
	local chance = 15 + mod.XalumLuckBonus(0, 20, 0.3)*100
    local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.SPINACH_PIE)
	if rng:RandomInt(100) < chance then
        TearFlagsLib.AddTearFlags(tear, flag)
        tear.Color = spinchColor
		
		if familiar.Player:HasCollectible(TrinketType.TRINKET_BABY_BENDER) then
			local spinchColor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			tear.Color = spinchColor
		end
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local spinchColor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
			spinchColor.A = spinchColor.A / 4
			tear.Color = spinchColor
		end
    end
end, FiendFolio.ITEM.COLLECTIBLE.SPINACH_PIE)