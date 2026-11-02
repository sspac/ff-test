local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_CAMO_UNDIES)
end, nil, CollectibleType.COLLECTIBLE_CAMO_UNDIES)]]

mod:AddCallback("POST_GUN_FIRE_TEAR", function(_, gun, player, tear)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_CAMO_UNDIES) and not mod:GetEntityData(gun).CamoUndiesFired then
		local effects = player:GetEffects()
		if not effects:HasNullEffect(NullItemID.ID_CAMO_BOOST) and effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_CAMO_UNDIES) then
			effects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_CAMO_UNDIES, -1)
			effects:RemoveNullEffect(NullItemID.ID_CAMO_BOOST, -1)
			effects:AddNullEffect(NullItemID.ID_CAMO_BOOST, nil, 30)
			if player:GetPlayerType() == mod.PLAYER.BRIEND then
				local twin = player:GetOtherTwin()
				if twin then
					local twineffects = twin:GetEffects()
					twineffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_CAMO_UNDIES, -1)
					twineffects:RemoveNullEffect(NullItemID.ID_CAMO_BOOST, -1)
					twineffects:AddNullEffect(NullItemID.ID_CAMO_BOOST, nil, 30)
				end
			end
			
			for _, entity in ipairs(Isaac.FindInRadius(player.Position, 80, EntityPartition.ENEMY)) do
				if entity:ToNPC() and not mod:isFriend(entity) then
					entity:TakeDamage(15, 0, EntityRef(player), 0)
				end
			end
			
			local poof = Isaac.Spawn(1000, 16, 1, player.Position, Vector.Zero, player)
			poof.SpriteScale = Vector(0.8, 0.8)
			sfx:Play(SoundEffect.SOUND_BLACK_POOF)
			game:ShakeScreen(10)
		end
		
		if effects:HasNullEffect(NullItemID.ID_CAMO_BOOST) then
			mod:GetEntityData(gun).CamoUndiesFired = true
			TearFlagsLib.AddTearFlags(tear, mod.CritFlag)
			local td = mod:GetEntityData(tear)
			if not td.critLightning or not td.critLightning:Exists() then
				sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, math.random(80,120)/100)
				local critLightning = Isaac.Spawn(1000, 1737, 1, tear.Position, Vector.Zero, tear):ToEffect()
				critLightning.Parent = tear
				critLightning.Color = Color(1,1,1,0,0,0,1)
				critLightning:Update()
				td.critLightning = critLightning
			end
			tear.Color = Color(1.3,1.3,1.3,1,100/255,-150/255,100/255)
		end
    end
end)

mod:AddCallback("PRE_GUN_UPDATE", function(_, gun, player)
    if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_CAMO_UNDIES) and mod:GetEntityData(gun).CamoUndiesFired then
        mod:GetEntityData(gun).CamoUndiesFired = nil
    end
end)