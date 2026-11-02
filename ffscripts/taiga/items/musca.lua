-- Musca --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("LOCUST_BOMB")

function mod:muscaBombFlag(entity, player, sourceFlag)
	if sourceFlag == mod.BombFlagSource.LOCUST_OF_WAR then return end
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MUSCA) then
		TearFlagsLib.AddTearFlags(entity, flag)
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, FiendFolio.ITEM.COLLECTIBLE.MUSCA, mod.muscaBombFlag)

function mod:muscaBombVariant(bomb, player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MUSCA) then
		local var = bomb.Variant
		if mod:isReplaceableBombVariant(var) then
			if mod:isCopperVariant(var) then
				bomb.Variant = mod.BOMB.LOCUST_COPPER
				bomb.Flags = bomb.Flags
			else
				bomb.Variant = mod.BOMB.LOCUST
				bomb.Flags = bomb.Flags
			end
		end
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SET_BOMB_VARIANT, FiendFolio.ITEM.COLLECTIBLE.MUSCA, mod.muscaBombVariant)

mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, function(_, pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
	if sourceFlag == mod.BombFlagSource.LOCUST_OF_WAR then return end
	
	local data = mod:GetEntityData(src)
	local frame = game:GetFrameCount()
	if data.FFLocustHasExploded == frame then return end
	
	local isReduced = sourceFlag == mod.BombFlagSource.DR_FETUS or 
	                  sourceFlag == mod.BombFlagSource.EPIC_FETUS or
	                  sourceFlag == mod.BombFlagSource.ANARCHISTS_EASY_BAKE or
	                  sourceFlag == mod.BombFlagSource.CLUB_EPIC_FETUS or
					  sourceFlag == mod.BombFlagSource.WRATHFUL_PLUSHIE
	if not isReduced or Isaac.CountEntities(nil, EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY) < 6 then 
		if not player or not player:Exists() then player = Isaac.GetPlayer(0) end
		
		local randAngle = math.random(360)
		local angles = {Vector.FromAngle(randAngle), Vector.FromAngle(randAngle + 120), Vector.FromAngle(randAngle + 240)}
		if isReduced or (bomb and bomb.RadiusMultiplier < 0.65) then 
			angles = {Vector.FromAngle(randAngle)}
		end
		
		for _, angle in ipairs(angles) do
			local drng = src:GetDropRNG()
			local subt = drng:RandomInt(5) + 1
			if Epiphany and drng:RandomFloat() < 0.444 then
				subt = drng:RandomInt(4) + 80
			end
			local locust = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, subt, src.Position, angle:Resized(10), player):ToFamiliar()
			locust.Player = player
			locust:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			locust:Update()
			local origColl = locust.EntityCollisionClass
			locust.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			mod.scheduleForUpdate(function()
				locust.EntityCollisionClass = origColl
			end, 1)
		end
	end
end, flag)

function mod:MuscaTakeDmg(ent, data, sourceEnt)
	data.LastDamageWasFly = sourceEnt and sourceEnt.Type == EntityType.ENTITY_FAMILIAR and sourceEnt.Variant == FamiliarVariant.BLUE_FLY
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, FiendFolio.ITEM.COLLECTIBLE.MUSCA, function(_, player)
    if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MUSCA) then
    	local luck = player.Luck
    	luck = luck < 0 and 0 or luck
    	luck = luck > 20 and 20 or luck
    	for _, n in pairs(Isaac.GetRoomEntities()) do
    		if n:IsEnemy() and n:IsDead() then
				local d = mod:GetEntityData(n)
				if not (d.CheckedMusca or d.LastDamageWasFly or (n.Type == mod.FFID.Tech and n.Variant > 999)) then
					if math.random(100) <= 100/6 + (luck * (100/3 - 100/6)/20) then
						local subt = n:GetDropRNG():RandomInt(5) + 1
						local locust = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, subt, n.Position, nilvector, player):ToFamiliar()
						locust.Player = player
						locust:Update()
					end
					d.CheckedMusca = true
				end
    		end
    	end
    end
end)
