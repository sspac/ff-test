local mod = FiendFolio
local game = Game()

local basicAng = 20

local flag = TearFlagsLib.RegisterTearFlag("QUANTUM")

local function spawnQuantumTear(tear, vel, player, tearLimit)
	local newTear = TearFlagsLib.FireSplitTear(tear, vel, player, {
		DamageMult = 1,
		ScaleMult = 1,
		SplitTearType = "FF_QUANTUM_GEODE"
	})
	newTear.Color = tear.Color
	newTear.Parent = tear.Parent
	newTear.Child = tear.Child
	newTear.CollisionDamage = tear.CollisionDamage
	newTear.Scale = tear.Scale
	newTear.FallingSpeed = tear.FallingSpeed
	newTear.FallingAcceleration = tear.FallingAcceleration
	newTear.CanTriggerStreakEnd = false
	newTear.TearFlags = tear.TearFlags

	return newTear
end

local avoidRecursive = 0
function mod:quantumGeodeFlagGeneric(entity, player, weaponFlag)
	if avoidRecursive > 0 then return end
	avoidRecursive = avoidRecursive + 1
	
	if player:HasTrinket(FiendFolio.ITEM.ROCK.QUANTUM_GEODE) then
		local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.QUANTUM_GEODE)
		local rng = player:GetTrinketRNG(mod.ITEM.ROCK.QUANTUM_GEODE)
		local tearLimit = 1
		if mod.HasTwoGeodes(player) then
			tearLimit = 2
		end
		
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
			TearFlagsLib.AddTearFlags(entity, flag)
			TearFlagsLib.SetTearFlagParams(entity, flag, {limit = tearLimit})
			
			local tears = {entity}
			local ang = 0
			if mult < 1 then
				if rng:RandomInt(2) == 0 then
					ang = -basicAng
				else
					ang = basicAng
				end
				local newTear = spawnQuantumTear(entity, entity.Velocity:Rotated(ang), player, tearLimit)
				table.insert(tears, newTear)
			else
				mult = math.ceil(mult)+1
				local pair = math.floor(mult/2)
				for i=1,pair do
					local adj = basicAng*i
					for j=-adj,adj,adj*2 do
						local newTear = spawnQuantumTear(entity, entity.Velocity:Rotated(j), player, tearLimit)
						table.insert(tears, newTear)
					end
				end
				if mult % 2 > 0 then
					ang = (pair+1)*basicAng
					if rng:RandomInt(2) == 0 then
						ang = -ang
					else
						ang = ang
					end
					local newTear = spawnQuantumTear(entity, entity.Velocity:Rotated(ang), player, tearLimit)
					table.insert(tears, newTear)
				end
			end
			
			for _, tear in ipairs(tears) do
				local ptrhash = GetPtrHash(tear)
				local otherTears = {}
				for _, othertear in ipairs(tears) do
					if GetPtrHash(othertear) ~= ptrhash then
						table.insert(otherTears, othertear)
					end
				end
				TearFlagsLib.SetTearFlagParams(tear, flag, {others = otherTears, splits = {tear}})
			end
		elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
			mod.scheduleForUpdate(function()
				avoidRecursive = avoidRecursive + 1
				
				TearFlagsLib.AddTearFlags(entity, flag)
				TearFlagsLib.SetTearFlagParams(entity, flag, {limit = tearLimit})
				
				local tears = {entity}
				local ang = 0
				if mult < 1 then
					if rng:RandomInt(2) == 0 then
						ang = -basicAng
					else
						ang = basicAng
					end
					local newTear = spawnQuantumTear(entity, entity.Velocity:Rotated(ang), player, tearLimit)
					table.insert(tears, newTear)
				else
					mult = math.ceil(mult)+1
					local pair = math.floor(mult/2)
					for i=1,pair do
						local adj = basicAng*i
						for j=-adj,adj,adj*2 do
							local newTear = spawnQuantumTear(entity, entity.Velocity:Rotated(j), player, tearLimit)
							table.insert(tears, newTear)
						end
					end
					if mult % 2 > 0 then
						ang = (pair+1)*basicAng
						if rng:RandomInt(2) == 0 then
							ang = -ang
						else
							ang = ang
						end
						local newTear = spawnQuantumTear(entity, entity.Velocity:Rotated(ang), player, tearLimit)
						table.insert(tears, newTear)
					end
				end
				
				for _, tear in ipairs(tears) do
					local ptrhash = GetPtrHash(tear)
					local otherTears = {}
					for _, othertear in ipairs(tears) do
						if GetPtrHash(othertear) ~= ptrhash then
							table.insert(otherTears, othertear)
						end
					end
					TearFlagsLib.SetTearFlagParams(tear, flag, {others = otherTears, splits = {tear}})
				end
				
				avoidRecursive = avoidRecursive - 1
			end, 1)
		elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
			TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.QUANTUM_PLANET_X)
			TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.QUANTUM_PLANET_X, {limit = tearLimit, num = math.floor(2 + mult)})
		end
	end
	
	avoidRecursive = avoidRecursive - 1
end
mod:AddPriorityTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, 1000000, FiendFolio.ITEM.ROCK.QUANTUM_GEODE, mod.quantumGeodeFlagGeneric)

function mod:quantumGeodeTearChecks(tear)
	if TearFlagsLib.HasTearFlags(tear, flag) then
		local ptrhash = GetPtrHash(tear)
		local params = TearFlagsLib.GetTearFlagParams(tear, flag)
		for _, othertear in ipairs(params.others) do
			if othertear:Exists() and not othertear:IsDead() and TearFlagsLib.HasTearFlags(othertear, flag) then
				local otherparams = TearFlagsLib.GetTearFlagParams(othertear, flag)
				otherparams.limit = otherparams.limit - 1
				if otherparams.limit <= 0 then
					TearFlagsLib.ClearTearFlags(othertear, flag)
					othertear:Remove()
					for i=1,7 do
						local ember = Isaac.Spawn(1000,66,0,othertear.Position, RandomVector()*math.random(10,45)/10, nil):ToEffect()
						ember.Color = Color(math.random(255)/255,math.random(255)/255,math.random(255)/255,1,0,0,0)
						ember.Scale = math.random(50,100)/100
						ember:SetTimeout(5)
						ember:Update()
					end
				else
					TearFlagsLib.SetTearFlagParams(othertear, flag, otherparams)
				end
			end
		end
		for _, splittear in ipairs(params.splits) do
			if splittear:Exists() and not splittear:IsDead() and TearFlagsLib.HasTearFlags(splittear, flag) then
				TearFlagsLib.ClearTearFlags(splittear, flag)
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_,tear,coll,low)
	if coll:ToNPC() and not mod:isFriend(coll) then
		mod:quantumGeodeTearChecks(tear)
	end
end)

mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source, weaponFlag)
	if source.Type == EntityType.ENTITY_TEAR then
		mod:quantumGeodeTearChecks(source)
	end
end, flag)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_SPLIT_TEAR, function(_, new, old, splittype)
	if TearFlagsLib.HasTearFlags(old, flag) and splittype ~= "FF_QUANTUM_GEODE" then
		local oldparams = TearFlagsLib.GetTearFlagParams(old, flag)
		
		for _, splittear in ipairs(oldparams.splits) do
			if splittear:Exists() and not splittear:IsDead() and TearFlagsLib.HasTearFlags(splittear, flag) then
				local splitparams = TearFlagsLib.GetTearFlagParams(splittear, flag)
				table.insert(splitparams.splits, new)
				TearFlagsLib.SetTearFlagParams(splittear, flag, splitparams)
			end
		end
		TearFlagsLib.SetTearFlagParams(new, flag, oldparams)
		
		for _, othertear in ipairs(oldparams.others) do
			if othertear:Exists() and not othertear:IsDead() and TearFlagsLib.HasTearFlags(othertear, flag) then
				local otherparams = TearFlagsLib.GetTearFlagParams(othertear, flag)
				table.insert(otherparams.others, new)
				TearFlagsLib.SetTearFlagParams(othertear, flag, otherparams)
			end
		end
	end
end)