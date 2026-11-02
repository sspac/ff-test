local mod = FiendFolio
local sfx = SFXManager()

mod.AmbassadorFlag = TearFlagsLib.RegisterTearFlag("AMBASSADOR")

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_BACKSTABBER)
end, nil, CollectibleType.COLLECTIBLE_BACKSTABBER)]]

mod:AddCallback("POST_GUN_FIRE_TEAR", function(_, gun, player, tear)
    if mod:ShouldRunSynergy(player, gun, CollectibleType.COLLECTIBLE_BACKSTABBER) then
		tear:ClearTearFlags(TearFlags.TEAR_BACKSTAB)
		TearFlagsLib.AddTearFlags(tear, mod.AmbassadorFlag)
	end
end)

function mod:ambassadorHit(tear, ent)
	if ent:IsEnemy() and TearFlagsLib.HasTearFlags(tear, mod.AmbassadorFlag) and not TearFlagsLib.HasTearFlags(tear, mod.CritFlag) then
		if (mod:GetEntityData(tear).preReloadBonusDamage or TearFlagsLib.GetTearFlagParams(tear, mod.AmbassadorFlag).Force) and mod:CompareVectors(ent.Velocity, (ent.Position-tear.Position), 100) then
			TearFlagsLib.AddTearFlags(tear, mod.CritFlag)
		end
	end
end

function mod.handleAmbassadorD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, mod.AmbassadorFlag, {Force = true})
end

--[[mod:AddCallback("PRE_GUN_UPDATE", function(_, gun, player)

end)]]