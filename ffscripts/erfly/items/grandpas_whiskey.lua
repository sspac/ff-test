local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local flag = TearFlagsLib.RegisterTearFlag("WHISKEY")

function mod.calculateWhiskeyRotation(player, rng)
    local luck = player.Luck
    local veer = math.min(math.max(5, 20 - (player.Luck * 3)), 90)
    local rotation = rng:RandomFloat() * veer
    if rng:RandomInt(2) == 1 then
        rotation = rotation * -1
    end
    return rotation
end

function mod.spawnWhiskeySplurt(player, vel)
    local shootVec = vel:Resized(player.ShotSpeed * 100)
    local d = mod:GetEntityData(player)
    if not d.whiskeySplurtFiring then
        for i = 1, mod:RandomInt(1,3) do
            local rng = player:GetDropRNG()
            local targetposition = player.Position + shootVec + mod:TrueRandomVector(rng):Resized(mod:RandomInt(10,30))
            local effect = Isaac.Spawn(1000, EffectVariant.BLOOD_DROP, 0, player.Position, (targetposition-player.Position):Resized(10*0.2+mod:getRoll(30,55,rng)/10):Rotated(mod:getRoll(-30,30,rng)), player):ToEffect()
            effect.Color = FiendFolio.ColorGrandpaWhiskey
            effect.Scale = 0.5
            effect.PositionOffset = Vector(0, -20-mod:RandomInt(1, 10))
            effect:Update()
            effect.FallingSpeed = -mod:getRoll(6,10,rng)
        end
        d.whiskeySplurtFiring = true
    end
end

function mod:updateGrandpasWhiskeyTearLaserColor(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY) then
		player.TearColor = player.TearColor * FiendFolio.ColorGrandpaWhiskeyTear
		player.LaserColor = player.LaserColor * FiendFolio.ColorGrandpaWhiskey
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY, mod.updateGrandpasWhiskeyTearLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:grandpasWhiskeyFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY) then
		TearFlagsLib.AddTearFlags(entity, flag)
		
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
			entity.Velocity = entity.Velocity:Rotated(mod.calculateWhiskeyRotation(player, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY)))
			mod.spawnWhiskeySplurt(player, entity.Velocity)
		elseif weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS or
		       weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or
		       weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY
		then
			entity.Velocity = entity.Velocity:Rotated(mod.calculateWhiskeyRotation(player, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY)))
		end
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY, mod.grandpasWhiskeyFlagGeneric)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY, mod.grandpasWhiskeyFlagGeneric)

function mod:grandpasWhiskeyPostTearUpdate(tear, tdata)
    if tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then 
		if TearFlagsLib.HasTearFlags(tear, flag) then
			tdata.WhiskeyDirection = tdata.WhiskeyDirection or RandomVector()
			tdata.WhiskeyDirection = tdata.WhiskeyDirection:Rotated(-21 + math.random(41))
			tear.Velocity = mod:Lerp(tear.Velocity, tdata.WhiskeyDirection:Resized(5), 0.05)
		else
			tdata.WhiskeyDirection = nil
		end
    end
end

function mod:grandpasWhiskeyThrowKnife(knife, player)
    if TearFlagsLib.HasTearFlags(knife, flag) then
        knife.Rotation = knife.Rotation + mod.calculateWhiskeyRotation(player, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY))
    end
end
mod:AddCallback(TearFlagsLib.Callback.POST_THROW_KNIFE, mod.grandpasWhiskeyThrowKnife)
mod:AddCallback(TearFlagsLib.Callback.POST_THROW_CLUB, mod.grandpasWhiskeyThrowKnife)

function mod:grandpasWhiskeyOnRocketFire(player, target)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY) then
        TearFlagsLib.AddTearFlags(target, flag)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, target)
    if TearFlagsLib.HasTearFlags(target, flag) then
		local data = mod:GetEntityData(target)
        data.WhiskeyDirection = data.WhiskeyDirection or RandomVector()
        data.WhiskeyDirection = data.WhiskeyDirection:Rotated(-21 + math.random(41))
        target.Velocity = mod:Lerp(target.Velocity, data.WhiskeyDirection:Resized(20), 0.05)
    end
end, EffectVariant.TARGET)

function mod:grandpasWhiskeyPeffectUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY) then
        local data = mod:GetEntityData(player)
        if data.whiskeySplurtFiring then
            local aim = mod.GetGoodShootingJoystick(player)
            if aim:Length() < 0.5 then
                data.whiskeySplurtFiring = nil
            end
        end

        local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY)
        if mult >= 2 then
            data.WhiskeyDirection = data.WhiskeyDirection or RandomVector()
            data.WhiskeyDirection = data.WhiskeyDirection:Rotated(-6 + math.random(11))
            player.Velocity = mod:Lerp(player.Velocity, data.WhiskeyDirection:Resized(player.MoveSpeed), 0.05)
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY, mod.grandpasWhiskeyPeffectUpdate)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY] = {
	FireCooldown = 15,
	TearColor = FiendFolio.ColorGrandpaWhiskeyTear,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,-46.310/255,-83.150/255,17.796/255,1.080,0.867,-0.062,1),
	EyeBColor = Color(1,1,1,1,-46.310/255,-83.150/255,17.796/255,1.080,0.867,-0.062,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.WHISKEY)
	
    tear.Velocity = tear.Velocity:Rotated(mod.calculateWhiskeyRotation(player, player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY)))
	mod.spawnWhiskeySplurt(player, tear.Velocity)
end, FiendFolio.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY)