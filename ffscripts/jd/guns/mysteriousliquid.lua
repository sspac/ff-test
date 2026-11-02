local mod = FiendFolio
local sfx = SFXManager()
local rng = RNG()

local flag = TearFlagsLib.RegisterTearFlag("SPLATTERSHOT")

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID)
end, nil, CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID)]]

mod:AddCallback("POST_GUN_FIRE_TEAR", function(_, gun, player, tear)
    if mod:ShouldRunSynergy(player, gun, CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) then
		TearFlagsLib.AddTearFlags(tear, flag)
		
		tear.FallingSpeed = rng:RandomFloat()*0.51 - player.TearRange*0.0003
        tear.FallingAcceleration = rng:RandomFloat()*0.5
		tear.Velocity = tear.Velocity+mod:TrueRandomVector(rng):Resized(4.4-player.TearRange*0.007)
		tear:ChangeVariant(TearVariant.BLUE)
	end
end)

mod:AddCallback("GUN_RELOAD_SHOT", function(_, gun, player)
    if mod:ShouldRunSynergy(player, gun, CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) then
		local targetposition = gun.Position + mod:TrueRandomVector(rng):Resized(mod:RandomInt(10,30)) --ferrium if you hadn't coded jugular i would be flailing in the dark rn
		local effect = Isaac.Spawn(1000, EffectVariant.BLOOD_DROP, 0, gun.Position, (targetposition-player.Position):Resized(10*0.2+mod:getRoll(30,55,rng)/10):Rotated(mod:getRoll(-30,30,rng)), player):ToEffect()
		effect.Color = FiendFolio.ColorIpecacProper
		effect.Scale = 0.5
		effect.PositionOffset = Vector(0, -20-mod:RandomInt(1, 10))
        effect:Update()
		effect.FallingSpeed = -mod:getRoll(6,10,rng)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	local teardata = mod:GetEntityData(tear)
	if TearFlagsLib.HasTearFlags(tear, flag) and tear.FrameCount % mod:RandomInt(5, 10) == 0 then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, tear.Position, Vector.Zero, mod:getPlayerFromTear(tear)):ToEffect()
		--effect.Timeout = 
	end
end)

--[[mod:AddCallback("PRE_GUN_UPDATE", function(_, gun, player)
    
end)]]