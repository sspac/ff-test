local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local flag = TearFlagsLib.RegisterTearFlag("PARANOIA")
mod.PocketRockitDisallowedCustomFlags = (mod.PocketRockitDisallowedCustomFlags or TearFlagsLib.BitSetInfinity.Zero) | flag

mod.PARANOIA = {}
mod.PARANOIA.PREVENT_APPLY = TearFlagsLib.WeaponFlag.DR_FETUS |
                             TearFlagsLib.WeaponFlag.EPIC_FETUS |
                             TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS
mod.PARANOIA.RATE_LIMITED = TearFlagsLib.WeaponFlag.LASER |
                            TearFlagsLib.WeaponFlag.KNIFE |
                            TearFlagsLib.WeaponFlag.BRIMSTONE_BALL |
                            TearFlagsLib.WeaponFlag.OCULAR_RIFT

local bal = {
    BulletCount = 8,
    AdditionalBulletCount = 2, --How many extra bullets stacking adds
    TweezerCount = 1,
    AdditionalTweezerCount = 1,

    SlowLength = 15, --How long does it slow em down
    SlowReduction = 0.9,

    DamageMult = 0.5,
    RangeMult = 0.5, --How much it multiplies falling speed / accel
    
    ReverseStart = 30, --Which frame it finally starts moving em back
    ReverseSpeedMult = -3,
    ReverseSpeedLerp = 0.05,
}

local paranoidFollowup

function mod:paranoiaTearUpdate(tear,tdata)
    if tdata.IsParanoidFollowup then
    	tdata.StartVec = tdata.StartVec or tear.Velocity
        if tear.FrameCount == 5 then
            tear.EntityCollisionClass = tdata.CollClass
        end
        if tear.FrameCount < bal.SlowLength then
            tear.Velocity = tear.Velocity * bal.SlowReduction
        elseif tear.FrameCount < bal.ReverseStart then
            tear.Velocity = mod:Lerp(tear.Velocity, tdata.StartVec * bal.ReverseSpeedMult, bal.ReverseSpeedLerp)
        end
    end
end

local function canFireParanoid(player)
    if not paranoidFollowup then
        local count = 0
        local tweezerCount = 0
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.PARANOIA) then
            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.PARANOIA)
            local chance = math.max(5 - (player.Luck * 0.5), 1)
            if rng:RandomFloat() * chance < 1 then
                count = count + bal.BulletCount + ((player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PARANOIA) - 1) * bal.AdditionalBulletCount)
            end
        end
        if player:HasTrinket(mod.ITEM.TRINKET.TWEEZERS) then
            local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.TWEEZERS)
            local chance = math.max(50 - (player.Luck * 5), 20)
			--print(chance)
            if rng:RandomFloat() * chance < 15 then
                tweezerCount = bal.TweezerCount + ((player:GetTrinketMultiplier(mod.ITEM.TRINKET.TWEEZERS) - 1) * bal.AdditionalTweezerCount)
                count = count + tweezerCount
            end
        end

        if count > 0 then
            return count, tweezerCount
        else
            return false
        end
    end
end

local PARANOIA_COLOUR = mod.ColorFunkyRed
local FOLLOWUP_COLOUR = mod.ColorGreyscaleDark

local function procParaoniaEffect(spawner, ent, count, source)
	local player = spawner:ToPlayer() or Isaac.GetPlayer()
	local familiar = spawner:ToFamiliar()
    local count = (count or bal.BulletCount)
    local startVec = RandomVector():Resized(9)
    local emergeSpot = ent.Position

    paranoidFollowup = true
	mod.IgnoreSecondaryFireEffects = true
    local increment = 360/count
    for i = 1, count do
        local rot = i * increment
        local spawnSpot = Vector(emergeSpot.X, emergeSpot.Y)
        spawnSpot = spawnSpot + startVec:Rotated(rot):Resized(ent.Size)
		local newTear = TearFlagsLib.FireSplitTear(source, startVec:Rotated(rot), familiar and familiar.Player or player, {
			RemoveCustomFlags = TearFlagsLib.Flag.PARANOIA,
			RemoveFlags = TearFlags.TEAR_QUADSPLIT | TearFlags.TEAR_SPLIT,

			TearVariant = TearVariant.CUPID_BLUE,
			PositionOverride = emergeSpot,
			DamageMult = bal.DamageMult,
			ScaleOverride = 0.8,
			ColorOverride = FOLLOWUP_COLOUR,

			SplitTearType = "FF_PARANOIA"
		})
		
		if source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == mod.ITEM.FAMILIAR.PLANET_X then
			TearFlagsLib.GetCustomVanillaTearFlagParams(newTear).ScaleOverride = nil
			TearFlagsLib.GetCustomVanillaTearFlagParams(newTear).ColorOverride = nil
			newTear.Scale = TearFlagsLib.GetCustomVanillaTearFlagParams(source).ScaleOverride * 0.75
		end

		if familiar then
			newTear.Height = -23.75
			newTear.FallingSpeed = 0.1 + math.random() * 0.2
			newTear.FallingAcceleration = 0.0

			if Sewn_API then
				if Sewn_API:IsUltra(data) then
					newTear.CollisionDamage = newTear.CollisionDamage * 1.5
					newTear.Scale = newTear.Scale * 1.1
				elseif Sewn_API:IsSuper(data) then
					newTear.CollisionDamage = newTear.CollisionDamage * 1.25
					newTear.Scale = newTear.Scale * 1.05
				end
			end

			newTear:ResetSpriteScale()
			if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
				local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
				newTear.Color = tearcolor
			end

			if mod:isSuperpositionedPlayer(familiar.Player) then
				local tearcolor = Color.Lerp(newTear.Color, Color(1,1,1,1,0,0,0), 0)
				tearcolor.A = tearcolor.A / 4
				newTear.Color = tearcolor
				newTear.CollisionDamage = newTear.CollisionDamage/4
			end
		end

        newTear.Position = newTear.Position + startVec:Rotated(rot):Resized(newTear.Size)
        newTear:AddTearFlags(TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL)

        mod:GetEntityData(newTear).CollClass = newTear.EntityCollisionClass
        newTear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        mod:GetEntityData(newTear).IsParanoidFollowup = true
        mod:GetEntityData(newTear).SpawnerEnt = ent
        newTear.FallingAcceleration = ((newTear.FallingAcceleration + 0.1) * bal.RangeMult) - 0.1
        newTear.FallingSpeed = ((newTear.FallingSpeed + 0.1) * bal.RangeMult) - 0.1
    end
    paranoidFollowup = false
	mod.IgnoreSecondaryFireEffects = false
end

function mod:paranoiaFlagGeneric(entity, player, weaponFlag)
	if paranoidFollowup then return end
	
	local paranoidCount, tweezerCount = canFireParanoid(player)
    if paranoidCount then
		TearFlagsLib.AddTearFlags(entity, flag)
		TearFlagsLib.SetTearFlagParams(entity, flag, {Count = paranoidCount})
		
		local changeVariant, color = false, FOLLOWUP_COLOUR
		if paranoidCount > tweezerCount then
			changeVariant, color = true, PARANOIA_COLOUR
		end	
		
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
			if changeVariant then mod:changeTearVariant(entity, TearVariant.EYE, TearVariant.EYE_BLOOD) end
			entity.Color = color
		elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
			mod:GetEntityData(entity).FFAquariusColor = color
		elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
			mod:GetEntityData(entity).FFExplosionColor = color
		elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
		       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
		       weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
		       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
		       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
		       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
		       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
		       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
		       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
		then
			return
		else
			entity.Color = color
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.paranoiaFlagGeneric)

function mod.handleParanoiaD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, flag, {Count = 8})
end

function mod:applyParanoiaFlag(entity, player, source, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
		local fdata = mod:GetEntityData(source)
		if fdata.ParanoiaCooldown ~= nil then
			return
		end
	end
	if not mod.PARANOIA.PREVENT_APPLY:HasAnyFlag(weaponFlag) then
		local edata = mod:GetEntityData(entity)
		if not (mod.PARANOIA.RATE_LIMITED:HasAnyFlag(weaponFlag) and edata.paranoiaDenied) then
			procParaoniaEffect(player, entity, TearFlagsLib.GetTearFlagParams(source, flag).Count, source)
			
			if mod.PARANOIA.RATE_LIMITED:HasAnyFlag(weaponFlag) then
				edata.paranoiaDenied = 30
			end
			if weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
				local fdata = mod:GetEntityData(source)
				fdata.ParanoiaCooldown = player.MaxFireDelay
			end
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyParanoiaFlag, flag)

function mod:paranoiaTearColl(tear,ent,tdata)
    if not tdata.ff_noCollideFrames then
        if tdata.IsParanoidKnifeSewing then
            local familiar = tear.SpawnerEntity:ToFamiliar() or Isaac.GetPlayer()
            procParaoniaEffect(familiar, ent, tdata.IsParanoidKnifeSewing, tear)
            tdata.IsParanoidKnifeSewing = false
        end
    end
end

function mod:paranoiaPostExplosion(explosion, player, source, weaponFlag)
	local frame = game:GetFrameCount()
	if mod:GetEntityData(source).didParanoia ~= frame then
		procParaoniaEffect(player, source, TearFlagsLib.GetTearFlagParams(source, flag).Count, source)
		mod:GetEntityData(source).didParanoia = frame
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_EXPLOSION_TEARFLAG_EFFECT, mod.paranoiaPostExplosion, flag)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.PARANOIA] = {
	BodyColor = Color(1,1,1,1,12.442/255,-5.027/255,-5.027/255,0.743,0.035,0.035,1),
	EyeAColor = Color(1,1,1,1,12.442/255,-5.027/255,-5.027/255,0.743,0.035,0.035,1),
	EyeBColor = Color(1,1,1,1,12.442/255,-5.027/255,-5.027/255,0.743,0.035,0.035,1)}

local function canFireParanoidSewing(player)
    local count = 0
    
	local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.PARANOIA)
    if rng:RandomFloat() * 5 < 1 then
        count = count + 8
    end

    if count > 0 then
        return count
    else
        return false
    end
end

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
    local paranoidCount = canFireParanoidSewing(familiar.Player)
    if paranoidCount then
        mod:GetEntityData(tear).IsParanoidKnifeSewing = paranoidCount
        tear.Color = PARANOIA_COLOUR
		mod:changeTearVariant(tear, TearVariant.EYE, TearVariant.EYE_BLOOD)
		
		if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			tear.Color = tearcolor
		end
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
			tearcolor.A = tearcolor.A / 4
			tear.Color = tearcolor
		end
    end
end, FiendFolio.ITEM.COLLECTIBLE.PARANOIA)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, entity)
    local tdata = mod:GetEntityData(tear)
    if tear.FrameCount <= 5 and tdata.IsParanoidFollowup then
        if tdata.SpawnerEnt.InitSeed == entity.InitSeed then
        	return false
        end
    end
end)

function mod:paranoiaEntityUpdate(npc, data)
	if data.paranoiaDenied then
		data.paranoiaDenied = data.paranoiaDenied - 1
		if data.paranoiaDenied <= 0 then
			data.paranoiaDenied = nil
		end
	end
end